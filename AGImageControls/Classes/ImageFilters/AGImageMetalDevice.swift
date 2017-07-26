//
//  AGImageMetalDevice.swift
//  AGPosterSnap
//
//  Created by Michael Liptuga on 25.07.17.
//  Copyright © 2017 Agilie. All rights reserved.
//

import UIKit
import Metal

internal class AGImageMetalDevice: AGImageDevice {
    
    internal let device: MTLDevice
    internal let commandQueue: MTLCommandQueue
    
    internal var drawRect: CGRect?
    internal var texture: MTLTexture?
    internal var outputTexture: MTLTexture?
    
    internal override init() {
        self.device = MTLCreateSystemDefaultDevice()!
        self.commandQueue = self.device.makeCommandQueue()
        super.init()
    }
    
    internal func makeTexture() {
        let width = Int(self.drawRect!.width)
        let height = Int(self.drawRect!.height)
        
        guard self.texture == nil else { return }
        guard let imageRef = self.cgImage else { return }
        defer { self.image = nil }
        
        let scale = self.imageScale
        
        let memorySize = width * height * 4
        let memoryPool = UnsafeMutablePointer<UInt8>.allocate(capacity: memorySize)
        defer { memoryPool.deallocate(capacity: memorySize) }
        memset(memoryPool, 0, memorySize)
        
        let bitmapContext = CGContext(
            data: memoryPool,
            width: width,
            height: height,
            bitsPerComponent: 8,
            bytesPerRow: width * 4,
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: (CGBitmapInfo.byteOrder32Big.rawValue | CGImageAlphaInfo.premultipliedLast.rawValue)
        )
        
        guard let context = bitmapContext else { return }
        
        let size = self.scale ?? self.spaceSize
        let tempX = self.offset.x
        let tempY = self.offset.y
        context.saveGState()
        context.setBlendMode(.normal)
        context.setAlpha(self.opacity)
        
        if let rotateRadius = self.rotate {
            context.translateBy(
                x: self.spaceSize.width * 0.5,
                y: self.spaceSize.height * 0.5
            )
            context.rotate(by: rotateRadius)
            
            self.draw(
                imageRef,
                in: CGRect(
                    x: (-size.width * 0.5 + tempX) * scale,
                    y: (-size.height * 0.5 + tempY) * scale,
                    width: size.width * scale,
                    height: size.height * scale
                ),
                on: context
            )
        } else {
            self.draw(
                imageRef,
                in: CGRect(
                    x: tempX * scale,
                    y: tempY * scale,
                    width: size.width * scale,
                    height: size.height * scale
                ),
                on: context
            )
        }
        context.restoreGState()
        
        let descriptor = MTLTextureDescriptor.texture2DDescriptor(
            pixelFormat: .rgba8Unorm,
            width: width,
            height: height,
            mipmapped: false
        )
        
        let texture = self.device.makeTexture(descriptor: descriptor)
        texture.replace(
            region: MTLRegionMake2D(0, 0, width, height),
            mipmapLevel: 0,
            withBytes: memoryPool,
            bytesPerRow: width * 4
        )
        
        self.texture = texture
        self.outputTexture = self.device.makeTexture(descriptor: descriptor)
    }
    internal func swapBuffer() {
        let oldTexture = self.texture
        self.texture = self.outputTexture
        self.outputTexture = oldTexture
    }
    
    internal override func beginGenerate(_ isAlphaProcess: Bool) {
        /// Space Size
        let scale = self.imageScale
        
        /// Calc size
        let tempW = self.spaceSize.width
        let tempH = self.spaceSize.height
        let width = Int(tempW * scale)
        let height = Int(tempH * scale)
        let spaceRect = CGRect(
            x: 0,
            y: 0,
            width: width,
            height: height
        )
        self.drawRect = spaceRect
        
        self.makeTexture()
    }
    internal override func endGenerate() -> CGImage? {
        guard let texture = self.texture else { return nil }
        defer {
            self.texture = nil
            self.outputTexture = nil
        }
        
        let scale = self.imageScale
        
        let width = Int(self.drawRect!.width)
        let height = Int(self.drawRect!.height)
        
        let memorySize = width * height * 4
        let memoryPool = UnsafeMutablePointer<UInt8>.allocate(capacity: memorySize)
        defer { memoryPool.deallocate(capacity: memorySize) }
        
        texture.getBytes(
            memoryPool,
            bytesPerRow: width * 4,
            from: MTLRegionMake2D(0, 0, width, height),
            mipmapLevel: 0
        )
        
        let bitmapContext = CGContext(
            data: memoryPool,
            width: width,
            height: height,
            bitsPerComponent: 8,
            bytesPerRow: width * 4,
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: (CGBitmapInfo.byteOrder32Big.rawValue | CGImageAlphaInfo.premultipliedLast.rawValue)
        )
        
        guard let context = bitmapContext else { return nil }
        
        guard let cgImage = context.makeImage() else { return nil }
        return cgImage
    }
}
