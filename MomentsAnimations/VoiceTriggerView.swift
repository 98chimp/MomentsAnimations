//
//  VoiceTriggerView.swift
//
//  Code generated using QuartzCode 1.66.4 on 2019-09-06.
//  www.quartzcodeapp.com
//

import UIKit

@IBDesignable
class VoiceTriggerView: UIView, CAAnimationDelegate {
    
    var updateLayerValueForCompletedAnimation : Bool = false
    var animationAdded : Bool = false
    var completionBlocks = [CAAnimation: (Bool) -> Void]()
    var layers = [String: CALayer]()
    
    
    
    //MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupProperties()
        setupLayers()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        setupProperties()
        setupLayers()
    }
    
    var pulseAnimProgress: CGFloat = 0{
        didSet{
            if(!self.animationAdded){
                removeAllAnimations()
                addPulseAnimation()
                self.animationAdded = true
                layer.speed = 0
                layer.timeOffset = 0
            }
            else{
                let totalDuration : CGFloat = 3
                let offset = pulseAnimProgress * totalDuration
                layer.timeOffset = CFTimeInterval(offset)
            }
        }
    }
    
    override var frame: CGRect{
        didSet{
            setupLayerFrames()
        }
    }
    
    override var bounds: CGRect{
        didSet{
            setupLayerFrames()
        }
    }
    
    func setupProperties(){
        
    }
    
    func setupLayers(){
        self.backgroundColor = UIColor(red:1.00, green: 1.00, blue:1.00, alpha:1.0)
        
        let voice = CAShapeLayer()
        self.layer.addSublayer(voice)
        layers["voice"] = voice
        
        let mic = CAShapeLayer()
        self.layer.addSublayer(mic)
        layers["mic"] = mic
        
        resetLayerProperties(forLayerIdentifiers: nil)
        setupLayerFrames()
    }
    
    func resetLayerProperties(forLayerIdentifiers layerIds: [String]!){
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        if layerIds == nil || layerIds.contains("voice"){
            let voice = layers["voice"] as! CAShapeLayer
            voice.fillColor = UIColor(red: 223/255.0, green: 223/255.0, blue: 223/255.0, alpha: 1.0).cgColor
            voice.strokeColor = UIColor(red:0.998, green: 0.277, blue:0.00251, alpha:1).cgColor
            voice.lineWidth   = 0
        }
        if layerIds == nil || layerIds.contains("mic"){
            let mic = layers["mic"] as! CAShapeLayer
            mic.fillColor   = UIColor(red:0.211, green: 0.49, blue:0.636, alpha:1).cgColor
            mic.strokeColor = UIColor.black.cgColor
            mic.lineWidth   = 0
        }
        
        CATransaction.commit()
    }
    
    func setupLayerFrames(){
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        if let voice = layers["voice"] as? CAShapeLayer{
            voice.frame = CGRect(x: 0.205 * voice.superlayer!.bounds.width, y: 0.205 * voice.superlayer!.bounds.height, width: 0.59 * voice.superlayer!.bounds.width, height: 0.59 * voice.superlayer!.bounds.height)
            voice.path  = voicePath(bounds: layers["voice"]!.bounds).cgPath
        }
        
        if let mic = layers["mic"] as? CAShapeLayer{
            mic.frame = CGRect(x: 0.38 * mic.superlayer!.bounds.width, y: 0.32 * mic.superlayer!.bounds.height, width: 0.24 * mic.superlayer!.bounds.width, height: 0.36 * mic.superlayer!.bounds.height)
            mic.path  = micPath(bounds: layers["mic"]!.bounds).cgPath
        }
        
        CATransaction.commit()
    }
    
    //MARK: - Animation Setup
    
    func addPulseAnimation(reverseAnimation: Bool = false, totalDuration: CFTimeInterval = 3, endTime: CFTimeInterval = 1, completionBlock: ((_ finished: Bool) -> Void)? = nil){
        let endTime = endTime * totalDuration
        
        if completionBlock != nil{
            let completionAnim = CABasicAnimation(keyPath:"completionAnim")
            completionAnim.duration = endTime
            completionAnim.delegate = self
            completionAnim.setValue("pulse", forKey:"animId")
            completionAnim.setValue(true, forKey:"needEndAnim")
            layer.add(completionAnim, forKey:"pulse")
            if let anim = layer.animation(forKey: "pulse"){
                completionBlocks[anim] = completionBlock
            }
        }
        
        if !reverseAnimation{
            setupLayerFrames()
            resetLayerProperties(forLayerIdentifiers: ["voice"])
        }
        
        self.layer.speed = 1
        self.animationAdded = false
        
        let fillMode : CAMediaTimingFillMode = reverseAnimation ? .both : .forwards
        
        let voice = layers["voice"] as! CAShapeLayer
        
        ////Voice animation
        let voiceTransformAnim      = CAKeyframeAnimation(keyPath:"transform")
        voiceTransformAnim.values   = [NSValue(caTransform3D: CATransform3DIdentity),
                                       NSValue(caTransform3D: CATransform3DIdentity),
                                       NSValue(caTransform3D: CATransform3DIdentity),
                                       NSValue(caTransform3D: CATransform3DMakeScale(1.2, 1.2, 1)),
                                       NSValue(caTransform3D: CATransform3DIdentity),
                                       NSValue(caTransform3D: CATransform3DMakeScale(1.2, 1.2, 1)),
                                       NSValue(caTransform3D: CATransform3DIdentity),
                                       NSValue(caTransform3D: CATransform3DMakeScale(1.2, 1.2, 1)),
                                       NSValue(caTransform3D: CATransform3DIdentity),
                                       NSValue(caTransform3D: CATransform3DMakeScale(1.2, 1.2, 1)),
                                       NSValue(caTransform3D: CATransform3DIdentity),
                                       NSValue(caTransform3D: CATransform3DMakeScale(1.2, 1.2, 1)),
                                       NSValue(caTransform3D: CATransform3DIdentity),
                                       NSValue(caTransform3D: CATransform3DMakeScale(1.2, 1.2, 1)),
                                       NSValue(caTransform3D: CATransform3DIdentity)]
        voiceTransformAnim.keyTimes = [0, 0.0406, 0.12, 0.202, 0.247, 0.378, 0.429, 0.474, 0.571, 0.697, 0.731, 0.774, 0.826, 0.934, 1]
        voiceTransformAnim.duration = totalDuration
        
        var voicePulseAnim : CAAnimationGroup = QCMethod.group(animations: [voiceTransformAnim], fillMode:fillMode)
        if (reverseAnimation){ voicePulseAnim = QCMethod.reverseAnimation(anim: voicePulseAnim, totalDuration:totalDuration) as! CAAnimationGroup}
        voice.add(voicePulseAnim, forKey:"voicePulseAnim")
    }
    
    //MARK: - Animation Cleanup
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool){
        if let completionBlock = completionBlocks[anim]{
            completionBlocks.removeValue(forKey: anim)
            if (flag && updateLayerValueForCompletedAnimation) || anim.value(forKey: "needEndAnim") as! Bool{
                updateLayerValues(forAnimationId: anim.value(forKey: "animId") as! String)
                removeAnimations(forAnimationId: anim.value(forKey: "animId") as! String)
            }
            completionBlock(flag)
        }
    }
    
    func updateLayerValues(forAnimationId identifier: String){
        if identifier == "pulse"{
            QCMethod.updateValueFromPresentationLayer(forAnimation: layers["voice"]!.animation(forKey: "voicePulseAnim"), theLayer:layers["voice"]!)
        }
    }
    
    func removeAnimations(forAnimationId identifier: String){
        if identifier == "pulse"{
            layers["voice"]?.removeAnimation(forKey: "voicePulseAnim")
        }
        self.layer.speed = 1
    }
    
    func removeAllAnimations(){
        for layer in layers.values{
            layer.removeAllAnimations()
        }
        self.layer.speed = 1
    }
    
    //MARK: - Bezier Path
    
    func voicePath(bounds: CGRect) -> UIBezierPath{
        let voicePath = UIBezierPath(ovalIn:bounds)
        return voicePath
    }
    
    func micPath(bounds: CGRect) -> UIBezierPath{
        let micPath = UIBezierPath()
        let minX = CGFloat(bounds.minX), minY = bounds.minY, w = bounds.width, h = bounds.height;
        
        micPath.move(to: CGPoint(x:minX + 0.91176 * w, y: minY + 0.38889 * h))
        micPath.addCurve(to: CGPoint(x:minX + w, y: minY + 0.44306 * h), controlPoint1:CGPoint(x:minX + 0.9605 * w, y: minY + 0.38889 * h), controlPoint2:CGPoint(x:minX + w, y: minY + 0.41314 * h))
        micPath.addCurve(to: CGPoint(x:minX + 0.62504 * w, y: minY + 0.74032 * h), controlPoint1:CGPoint(x:minX + w, y: minY + 0.58607 * h), controlPoint2:CGPoint(x:minX + 0.84067 * w, y: minY + 0.70624 * h))
        micPath.addLine(to: CGPoint(x:minX + 0.625 * w, y: minY + 0.9375 * h))
        micPath.addCurve(to: CGPoint(x:minX + 0.52083 * w, y: minY + h), controlPoint1:CGPoint(x:minX + 0.625 * w, y: minY + 0.97202 * h), controlPoint2:CGPoint(x:minX + 0.57836 * w, y: minY + h))
        micPath.addCurve(to: CGPoint(x:minX + 0.41667 * w, y: minY + 0.9375 * h), controlPoint1:CGPoint(x:minX + 0.4633 * w, y: minY + h), controlPoint2:CGPoint(x:minX + 0.41667 * w, y: minY + 0.97202 * h))
        micPath.addLine(to: CGPoint(x:minX + 0.41667 * w, y: minY + 0.74576 * h))
        micPath.addCurve(to: CGPoint(x:minX, y: minY + 0.44306 * h), controlPoint1:CGPoint(x:minX + 0.18019 * w, y: minY + 0.7214 * h), controlPoint2:CGPoint(x:minX, y: minY + 0.59515 * h))
        micPath.addCurve(to: CGPoint(x:minX + 0.08824 * w, y: minY + 0.38889 * h), controlPoint1:CGPoint(x:minX, y: minY + 0.41314 * h), controlPoint2:CGPoint(x:minX + 0.0395 * w, y: minY + 0.38889 * h))
        micPath.addCurve(to: CGPoint(x:minX + 0.17647 * w, y: minY + 0.44306 * h), controlPoint1:CGPoint(x:minX + 0.13697 * w, y: minY + 0.38889 * h), controlPoint2:CGPoint(x:minX + 0.17647 * w, y: minY + 0.41314 * h))
        micPath.addCurve(to: CGPoint(x:minX + 0.5 * w, y: minY + 0.64167 * h), controlPoint1:CGPoint(x:minX + 0.17647 * w, y: minY + 0.55275 * h), controlPoint2:CGPoint(x:minX + 0.32132 * w, y: minY + 0.64167 * h))
        micPath.addCurve(to: CGPoint(x:minX + 0.82353 * w, y: minY + 0.44306 * h), controlPoint1:CGPoint(x:minX + 0.67868 * w, y: minY + 0.64167 * h), controlPoint2:CGPoint(x:minX + 0.82353 * w, y: minY + 0.55275 * h))
        micPath.addCurve(to: CGPoint(x:minX + 0.91176 * w, y: minY + 0.38889 * h), controlPoint1:CGPoint(x:minX + 0.82353 * w, y: minY + 0.41314 * h), controlPoint2:CGPoint(x:minX + 0.86303 * w, y: minY + 0.38889 * h))
        micPath.close()
        micPath.move(to: CGPoint(x:minX + 0.5 * w, y: minY))
        micPath.addCurve(to: CGPoint(x:minX + 0.70833 * w, y: minY + 0.13031 * h), controlPoint1:CGPoint(x:minX + 0.61506 * w, y: minY), controlPoint2:CGPoint(x:minX + 0.70833 * w, y: minY + 0.05834 * h))
        micPath.addLine(to: CGPoint(x:minX + 0.70833 * w, y: minY + 0.42525 * h))
        micPath.addCurve(to: CGPoint(x:minX + 0.5 * w, y: minY + 0.55556 * h), controlPoint1:CGPoint(x:minX + 0.70833 * w, y: minY + 0.49722 * h), controlPoint2:CGPoint(x:minX + 0.61506 * w, y: minY + 0.55556 * h))
        micPath.addCurve(to: CGPoint(x:minX + 0.29167 * w, y: minY + 0.42525 * h), controlPoint1:CGPoint(x:minX + 0.38494 * w, y: minY + 0.55556 * h), controlPoint2:CGPoint(x:minX + 0.29167 * w, y: minY + 0.49722 * h))
        micPath.addLine(to: CGPoint(x:minX + 0.29167 * w, y: minY + 0.13031 * h))
        micPath.addCurve(to: CGPoint(x:minX + 0.5 * w, y: minY), controlPoint1:CGPoint(x:minX + 0.29167 * w, y: minY + 0.05834 * h), controlPoint2:CGPoint(x:minX + 0.38494 * w, y: minY))
        micPath.close()
        micPath.move(to: CGPoint(x:minX + 0.5 * w, y: minY))
        
        return micPath
    }
    
    
}
