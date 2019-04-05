//
//  AnwserSurveyViewController.swift
//  ATKearneyApp
//
//  Created by Federico Lopez on 27/03/2019.
//  Copyright © 2019 Federico Lopez. All rights reserved.
//

import UIKit

class AnwserSurveyViewController: BaseViewController, UITextViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var sendReponseButton: UIButton!
    
    let VALUE_LABEL_TAG = 999
    let CHECK_IMG_TAG = 777
    var currentY: CGFloat = 0.0
    var answers = [Any]()
    
    
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.subviews.first!.backgroundColor = UIColor.white
        addFormBehavior(scrollview: scrollView, bottomContraint: bottomConstraint)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        CHANGE_LABEL_HEIGHT(label: titleLabel, text: SelectedSurvey.shared.title)
        CHANGE_LABEL_HEIGHT(label: descriptionLabel, text: SelectedSurvey.shared.description!, placeBelow: titleLabel, margin: 10.0)
        addLine(below: descriptionLabel, margin: 25.0)
        
        buildQuestions()
    }
    
    // MARK: - Button actions
    @IBAction func closeButtonTap(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - UI
    func addLine(below: UIView, margin: CGFloat) {
        let x = titleLabel.frame.origin.x
        let y = below.frame.origin.y + below.frame.size.height + margin
        let w = titleLabel.frame.size.width
        
        let lineView = UIView(frame: CGRect(x: x, y: y, width: w, height: 1))
        lineView.backgroundColor = COLOR_FROM_HEX("#D9D9D9")
        contentView.addSubview(lineView)
    }
    
    // MARK: - Questions
    func buildQuestions() {
        currentY = descriptionLabel.frame.origin.y + descriptionLabel.frame.size.height + 60.0
        
        for (index, Q) in SelectedSurvey.shared.questions.enumerated() {
            addQuestion(Q, index: index)
        }
        
        /*
        // Some examples
         
        var T = Question.QuestionType(rawValue: "scale")!
        var Q = Question(text: "Select a value", type: T, options: ["Min", "Max"])
        addQuestion(Q, index: 0)
        
        
        T = Question.QuestionType(rawValue: "multiple")!
        Q = Question(text: "Select some options", type: T, options: ["Option 1", "Option 2", "Option 3", "Option 4" ,"option 5"])
        addQuestion(Q, index: 1)
        
        
        T = Question.QuestionType(rawValue: "text")!
        Q = Question(text: "What do you think?", type: T, options: [])
        addQuestion(Q, index: 2)
        
        T = Question.QuestionType(rawValue: "yesNo")!
        Q = Question(text: "Yes or no?", type: T, options: ["Si", "No"])
        addQuestion(Q, index: 3)
        */
    }
    
    func addQuestion(_ Q: Question, index: Int) {
        if(Q.type == .text || Q.type == .yes_no) {
            answers.append("")
        } else if(Q.type == .multiple) {
            answers.append([])
        } else if(Q.type == .scale) {
            answers.append(5)
        }
        
        let X = titleLabel.frame.origin.x
        let W = titleLabel.frame.size.width
        let margin: CGFloat = 10.0
        let questionView = UIView(frame: CGRect(x: 0, y: currentY, width: self.view.frame.size.width, height: 100))
        questionView.backgroundColor = UIColor.white
        
        let textLabel = UILabel(frame: CGRect(x: X, y: 0, width: W, height: 10.0))
        textLabel.font = descriptionLabel.font
        questionView.addSubview(textLabel)
        CHANGE_LABEL_HEIGHT(label: textLabel, text: Q.text)
        
        if(Q.type == .text) {
            // TEXT
            let textView = UITextView(frame: CGRect(x: X, y: BOTTOM(view: textLabel) + 20.0, width: W, height: 85))
            textView.font = UIFont(name: "Graphik-Medium", size: 16)
            textView.backgroundColor = COLOR_FROM_HEX("#F2F2F2")
            textView.tag = index
            textView.autocapitalizationType = .none
            textView.autocorrectionType = .no
            textView.spellCheckingType = .no
            
            questionView.addSubview(textView)
            CHANGE_HEIGHT(view: questionView, BOTTOM(view: textView) + 35.0)
            textView.delegate = self
        } else if(Q.type == .yes_no) {
            // YES - NO (mutually exclusive)
            for i in 0...1 {
                var valX = X
                if(i==1){
                    valX = X + (W/2) + 5
                }
                
                let button = BorderedButton()
                button.titleLabel?.font = UIFont.systemFont(ofSize: 15.0)
                button.frame = CGRect(x: valX, y: BOTTOM(view: textLabel) + 20.0, width: (W/2)-5, height: 55)
                button.drawBorder()
                button.setTitle(Q.options[i].uppercased(), for: .normal)
                button.backgroundColor = UIColor.white
                button.isSelected = false
                button.setTitleColor(UIColor.black.withAlphaComponent(0.7), for: .normal)
                button.setTitleColor(UIColor.black, for: .selected)
                button.addTarget(self, action: #selector(yesNoButtonTap), for: .touchUpInside)
                button.titleLabel?.font = UIFont(name: "Graphik-Medium", size: 17)
                button.contentHorizontalAlignment = .left
                button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 70.0, bottom: 0, right: 0)
                button.tag = index
                questionView.addSubview(button)
                
                let imageView = UIImageView(frame: CGRect(x: 11, y: 16, width: 22, height: 22))
                imageView.tag = CHECK_IMG_TAG
                button.addSubview(imageView)
                
                CHANGE_HEIGHT(view: questionView, BOTTOM(view: button) + (margin*5))
            }
            
            for V in questionView.subviews {
                if(V is UIButton) {
                    yesNoButtonTap(sender: (V as! UIButton))
                    break
                }
            }
        } else if(Q.type == .multiple) {
            // Multiple options (non exclusives)
            var valY = BOTTOM(view: textLabel) + 30.0
            for option in Q.options {
                let button = BorderedButton()
                button.titleLabel?.font = UIFont.systemFont(ofSize: 15.0)
                button.frame = CGRect(x: X, y: valY, width: W, height: 55)
                button.setTitle(option, for: .normal)
                button.backgroundColor = UIColor.white
                button.drawBorder(color: COLOR_FROM_HEX("#DBD8D8"))
                button.isSelected = false
                button.setTitleColor(UIColor.black.withAlphaComponent(0.7), for: .normal)
                button.setTitleColor(UIColor.black, for: .selected)
                button.titleLabel?.font = UIFont(name: "Graphik-Medium", size: 17)
                button.addTarget(self, action: #selector(multipleButtonTap), for: .touchUpInside)
                button.contentHorizontalAlignment = .left
                button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 70.0, bottom: 0, right: 0)
                button.tag = index
                questionView.addSubview(button)
                
                let imageView = UIImageView(frame: CGRect(x: 11, y: 16, width: 22, height: 22))
                imageView.tag = CHECK_IMG_TAG
                imageView.image = UIImage(named: "checkOFF_2.png")
                button.addSubview(imageView)
                
                CHANGE_HEIGHT(view: questionView, BOTTOM(view: button) + (margin*5))
                valY += 55 + 10
            }
        } else if(Q.type == .scale) {
            // Scale value selection
            
            let valueLabel = UILabel(frame: CGRect(x: X, y: BOTTOM(view: textLabel) + (margin * 2), width: W, height: 21))
            valueLabel.text = "5"
            valueLabel.font = UIFont(name: "Graphik-Regular", size: 16)
            valueLabel.textAlignment = .center
            valueLabel.tag = VALUE_LABEL_TAG
            questionView.addSubview(valueLabel)
            
            let slider = UISlider(frame: CGRect(x: X, y: BOTTOM(view: valueLabel), width: W, height: 29))
            slider.minimumValue = 1
            slider.maximumValue = 10
            slider.value = 5.5
            slider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
            slider.tag = index
            slider.minimumTrackTintColor = UIColor.black
            slider.maximumTrackTintColor = COLOR_FROM_HEX("#DBD8D8")
            questionView.addSubview(slider)
            
            let minLabel = UILabel(frame: CGRect(x: X, y: BOTTOM(view: slider), width: W/2, height: 21))
            minLabel.text = Q.options[0]
            minLabel.font = UIFont(name: "Graphik-Regular", size: 16)
            questionView.addSubview(minLabel)
            
            let maxLabel = UILabel(frame: CGRect(x: X+(W/2), y: BOTTOM(view: slider), width: W/2, height: 21))
            maxLabel.text = Q.options[1]
            maxLabel.font = UIFont(name: "Graphik-Regular", size: 16)
            maxLabel.textAlignment = .right
            questionView.addSubview(maxLabel)
            
            CHANGE_HEIGHT(view: questionView, BOTTOM(view: minLabel) + (margin*5))
        }
        
        contentView.addSubview(questionView)
        PLACE(sendReponseButton, below: questionView, margin: margin * 4)
        
        currentY += questionView.frame.size.height
        CHANGE_HEIGHT(view: contentView, BOTTOM(view: sendReponseButton) + (margin*5))
        scrollView.contentSize = contentView.frame.size
    }
    
    // MARK: - Some events
    func textViewDidChange(_ textView: UITextView) {
        let index = textView.tag
        answers[index] = textView.text!
    }
    
    @objc func yesNoButtonTap(sender: UIButton) {
        let superView = sender.superview
        
        for V in superView!.subviews {
            if(V is UIButton) {
                let button = (V as! UIButton)
                
                button.isSelected = false
                (button.viewWithTag(CHECK_IMG_TAG) as! UIImageView).image = UIImage(named: "checkOFF_2.png")
                (button as! BorderedButton).drawBorder(color: COLOR_FROM_HEX("#DBD8D8"))
            }
        }

        sender.isSelected = true
        (sender as! BorderedButton).drawBorder(color: UIColor.black)
        (sender.viewWithTag(CHECK_IMG_TAG) as! UIImageView).image = UIImage(named: "checkON.png")
        answers[sender.tag] = sender.titleLabel!.text!
    }
    
    @objc func multipleButtonTap(sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        let superView = sender.superview
        var multipleAnswers = [String]()
        for V in superView!.subviews {
            if(V is UIButton) {
                let button = (V as! UIButton)
                
                if(button.isSelected) {
                    multipleAnswers.append(button.titleLabel!.text!)
                    (button as! BorderedButton).drawBorder(color: UIColor.black)
                    (button.viewWithTag(CHECK_IMG_TAG) as! UIImageView).image = UIImage(named: "checkON.png")
                } else {
                    (button.viewWithTag(CHECK_IMG_TAG) as! UIImageView).image = UIImage(named: "checkOFF_2.png")
                    (button as! BorderedButton).drawBorder(color: COLOR_FROM_HEX("#DBD8D8"))
                }
            }
        }

        answers[sender.tag] = multipleAnswers
    }
    
    @objc func sliderValueChanged(sender: UISlider) {
        let valueLabel = sender.superview?.viewWithTag(VALUE_LABEL_TAG) as! UILabel
        
        let value = Int(roundf(sender.value))
        valueLabel.text = String(value)
        
        answers[sender.tag] = value
    }
    
    // MARK: - Button actions
    func validateForm() -> Bool {
        var result = true
        
        for A in answers {
            if(A is String) {
                if( (A as! String).isEmpty ) {
                    ALERT(title_ERROR, text_ANSWER_TEXT_EMPTY, viewController: self)
                    result = false
                    break
                }
            } else if(A is Array<String>) {
                if( (A as! Array<String>).count == 0 ) {
                    ALERT(title_ERROR, text_ANSWER_MULTIPLE_0, viewController: self)
                    result = false
                    break
                }
            }
        }
        
        return result
    }
    
    
    @IBAction func sendResponseButtonTap(_ sender: UIButton) {
        if(!validateForm()) {
            return
        }
        
        var answersDict = [String: Any]()
        for (i, value) in answers.enumerated() {
            let key = String(i)
            if(value is Array<String>) {
                
                var multipleDict = [String: String]()
                for (j, option) in (value as! Array<String>).enumerated() {
                    multipleDict[ String(j) ] = option
                }
                
                answersDict[key] = multipleDict
            } else {
                answersDict[key] = value
            }
        }
        print(answersDict)
        
        let info = [
            "ATKMember": IS_ATK_MEMBER(email: MyUser.shared.userID),
            "info": answersDict
            ] as [String : Any]
        print(info)
        
        showLoading(true)
        FirebaseManager.shared.answerSurvey(surveyID: SelectedSurvey.shared.surveyID, userID: MyUser.shared.userID, info: info){ (error) in
            if(error==nil) {
                self.performSegue(withIdentifier: "gotoThanks", sender: self)
            } else {
                ALERT(title_ERROR, text_GENERIC_ERROR, viewController: self)
            }
            
            self.showLoading(false)
        }
    }
    
    
}
