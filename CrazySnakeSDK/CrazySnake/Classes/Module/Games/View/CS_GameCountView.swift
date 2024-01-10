//
//  CS_GameCountView.swift
//  CrazySnake
//
//  Created by Lee on 22/05/2023.
//

import UIKit

class CS_GameCountView: UIView {
    
    var time = 0
    var sesssionEndAction: CS_NoParasBlock?
    
    var countdownTimer: Timer?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
        initTimer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        countdownTimer?.invalidate()
        LSLog("CS_GameCountView deinit")
    }
    
    func initTimer() {
        guard countdownTimer == nil else {
            return
        }
        weak var weakSelf = self
        countdownTimer = Timer(timeInterval: 1.0, repeats: true) { timer in
            if weakSelf?.time ?? 0 > 0 {
                weakSelf?.time -= 1
                weakSelf?.countdownLabel.text = weakSelf?.timeFormat(weakSelf?.time ?? 0)
            } else {
                weakSelf?.time = 0
                weakSelf?.countdownLabel.text = "crazy_str_round_ending_".ls_localized
            }
        }
        RunLoop.current.add(countdownTimer!, forMode: .default)
    }
    
    func updateSessionInfo(_ sessionInfo: CS_SessionInfoModel?){
        guard let model = sessionInfo else { return }
        
        if model.status == .beging {
            time = Int(model.close_time - model.current_time)
            countdownIcon.isHidden = false
            countdownTipsLabel.isHidden = false
            countdownLabel.text = timeFormat(time)
            countdownTimer?.fire()
        } else {
            countdownIcon.isHidden = true
            countdownTipsLabel.isHidden = true
            countdownLabel.text = "crazy_str_round_ending_".ls_localized
        }
    }
    
    func timeFormat(_ need: Int) -> String{
        guard need > 0 else {
            return "Ending"
        }
        let hourSecond = 60*60
        let minuteSecond = 60
        let hourLeft = need%hourSecond
        let minute = hourLeft/minuteSecond
        let second = hourLeft%minuteSecond
        
        if minute > 0 {
            if second > 9 {
                return "0\(minute):\(second)"
            } else {
                return "0\(minute):0\(second)"
            }
        } else {
            if second > 9 {
                return "00:\(second)"
            } else {
                return "00:0\(second)"
            }
        }
    }
    
    lazy var countdownView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage.ls_bundle("games_bg_guess_timedown@2x")
        return view
    }()
    
    lazy var countdownIcon: UIImageView = {
        let view = UIImageView()
        view.image = UIImage.ls_bundle("stake_icon_token_stake_time@2x")
        return view
    }()
    
    lazy var countdownLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_white(), .ls_JostRomanFont(30))
        label.textAlignment = .center
        label.text = "Ending".ls_localized
        return label
    }()
    
    lazy var countdownTipsLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_text_gray(), .ls_JostRomanFont(12))
        label.textAlignment = .center
        label.text = "crazy_str_countdown".ls_localized
        label.isHidden = true
        return label
    }()
    

}

//MARK: UI
extension CS_GameCountView {
    
    private func setupView() {
        addSubview(countdownView)
        countdownView.addSubview(countdownIcon)
        countdownView.addSubview(countdownLabel)
        countdownView.addSubview(countdownTipsLabel)
        
        countdownView.snp.makeConstraints { make in
            make.edges.equalTo(0)
        }
        
        countdownLabel.snp.makeConstraints { make in
            make.centerX.equalTo(countdownView)
            make.top.equalTo(countdownView).offset(8)
        }
        
        countdownIcon.snp.makeConstraints { make in
            make.centerY.equalTo(countdownLabel)
            make.right.equalTo(countdownLabel.snp.left).offset(-2)
            make.width.height.equalTo(15)
        }
        
        countdownTipsLabel.snp.makeConstraints { make in
            make.centerX.equalTo(countdownView)
            make.bottom.equalTo(countdownView).offset(-2)
        }
    }
}
