import UIKit

protocol ShortVideoSliderDelegete: AnyObject {
    func beginTracking()
    func endTracking(value: Float)
    func valueDidChange(value: Float, slider: UISlider)
}

class ShortVideoSlider: UISlider {
    weak var delegate: ShortVideoSliderDelegete?
    
    // ジェスチャー認識のための変数を追加
    private var longPressRecognizer: UILongPressGestureRecognizer!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        // スライダーのプログレスの色を設定
        self.minimumTrackTintColor = UIColor.red

        // スライダーのベースの色を設定
        self.maximumTrackTintColor = UIColor.gray
        
        // 初期状態ではつまみを非表示にする
        setThumbImage(UIImage(), for: .normal)
        
        // ロングプレスジェスチャーを追加
        longPressRecognizer = UILongPressGestureRecognizer(
            target: self,
            action: #selector(handleLongPress)
        )
        addGestureRecognizer(longPressRecognizer)
        
        // スライダーの値が変わるたびに呼ばれるアクションを追加
        addTarget(
            self,
            action: #selector(sliderValueChanged),
            for: .valueChanged
        )
    }
    
    @objc private func sliderValueChanged(slider: UISlider) {
        // スライダーの値が変わるたびにデリゲートメソッドを呼び出す
        delegate?.valueDidChange(value: self.value, slider: slider)
    }
    
    @objc private func handleLongPress(
        gestureRecognizer: UILongPressGestureRecognizer
    ) {
        let location = gestureRecognizer.location(in: self)
        let value = minimumValue + Float(location.x / bounds.width) * (maximumValue - minimumValue)
        
        // 長押し中にスライダーの値を更新
        if gestureRecognizer.state == .began || gestureRecognizer.state == .changed {
            setValue(value, animated: true)
            sendActions(for: .valueChanged)
        }
    }
    
    override func beginTracking(
        _ touch: UITouch,
        with event: UIEvent?
    ) -> Bool {
        delegate?.beginTracking()
        
        let location = touch.location(in: self)
        
        // スライダーのトラックに対するタッチ位置の計算
        let value = minimumValue + Float(location.x / bounds.width) * (maximumValue - minimumValue)
        
        // タップされた位置にスライダーの値を即座に設定
        setValue(value, animated: true)
        sendActions(for: .valueChanged)
        
        // カスタムのつまみ画像を設定
        setThumbImage(UIImage(systemName: "rectangle.portrait.fill")?.withTintColor(.lightGray, renderingMode: .alwaysOriginal), for: .normal)
        return super.beginTracking(touch, with: event)
    }
    
    override func continueTracking(
        _ touch: UITouch,
        with event: UIEvent?
    ) -> Bool {
        // 通常のドラッグ動作
        return super.continueTracking(touch, with: event)
    }
    
    override func endTracking(
        _ touch: UITouch?,
        with event: UIEvent?
    ) {
        delegate?.endTracking(value: value)
        setThumbImage(UIImage(), for: .normal)
        super.endTracking(touch, with: event)
    }
    
    // タップされた時につまみが即座に移動するようにする
    override func point(
        inside point: CGPoint,
        with event: UIEvent?
    ) -> Bool {
        let bounds = self.bounds.insetBy(dx: -10, dy: -10) // タッチ領域を広げるために必要に応じて調整
        return bounds.contains(point)
    }
}
