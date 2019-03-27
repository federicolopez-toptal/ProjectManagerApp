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
        addLine(below: descriptionLabel, margin: 10.0)
        
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
        lineView.backgroundColor = UIColor.lightGray
        contentView.addSubview(lineView)
    }
    
    // MARK: - Questions
    func buildQuestions() {
        currentY = descriptionLabel.frame.origin.y + descriptionLabel.frame.size.height + 20.0
        
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
        
        let textLabel = UILabel(frame: CGRect(x: X, y: margin, width: W, height: 10.0))
        questionView.addSubview(textLabel)
        CHANGE_LABEL_HEIGHT(label: textLabel, text: Q.text)
        
        if(Q.type == .text) {
            // TEXT
            let textView = UITextView(frame: CGRect(x: X, y: BOTTOM(view: textLabel) + margin, width: W, height: 96))
            textView.backgroundColor = COLOR_FROM_HEX("#D9D9D9")
            textView.tag = index
            
            questionView.addSubview(textView)
            CHANGE_HEIGHT(view: questionView, BOTTOM(view: textView) + (margin*2))
            textView.delegate = self
        } else if(Q.type == .yes_no) {
            // YES - NO (mutually exclusive)
            for i in 0...1 {
                var valX = X
                if(i==1){
                    valX = X + (W/2)
                }
                
                let button = UIButton(type: .custom)
                button.frame = CGRect(x: valX, y: BOTTOM(view: textLabel) + margin, width: W/2, height: 30)
                button.setTitle(Q.options[i], for: .normal)
                button.backgroundColor = COLOR_FROM_HEX("#D9D9D9")
                button.isSelected = false
                button.setTitleColor(UIColor.lightGray, for: .normal)
                button.setTitleColor(UIColor.black, for: .selected)
                button.addTarget(self, action: #selector(yesNoButtonTap), for: .touchUpInside)
                button.tag = index
                questionView.addSubview(button)
                
                CHANGE_HEIGHT(view: questionView, BOTTOM(view: button) + (margin*2))
            }
            
            for V in questionView.subviews {
                if(V is UIButton) {
                    yesNoButtonTap(sender: (V as! UIButton))
                    break
                }
            }
        } else if(Q.type == .multiple) {
            // Multiple options (non exclusives)
            var valY = BOTTOM(view: textLabel) + margin
            for option in Q.options {
                let button = UIButton(type: .custom)
                button.frame = CGRect(x: X, y: valY, width: W, height: 30)
                button.setTitle(option, for: .normal)
                button.backgroundColor = COLOR_FROM_HEX("#D9D9D9")
                button.isSelected = false
                button.setTitleColor(UIColor.lightGray, for: .normal)
                button.setTitleColor(UIColor.black, for: .selected)
                button.addTarget(self, action: #selector(multipleButtonTap), for: .touchUpInside)
                button.tag = index
                questionView.addSubview(button)
                
                CHANGE_HEIGHT(view: questionView, BOTTOM(view: button) + (margin*2))
                valY += 30.0 + 5
            }
        } else if(Q.type == .scale) {
            // Scale value selection
            
            let valueLabel = UILabel(frame: CGRect(x: X, y: BOTTOM(view: textLabel), width: W, height: 21))
            valueLabel.text = "5"
            valueLabel.textAlignment = .center
            valueLabel.tag = VALUE_LABEL_TAG
            questionView.addSubview(valueLabel)
            
            let slider = UISlider(frame: CGRect(x: X, y: BOTTOM(view: valueLabel), width: W, height: 29))
            slider.minimumValue = 1
            slider.maximumValue = 10
            slider.value = 5.5
            slider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
            slider.tag = index
            questionView.addSubview(slider)
            
            let minLabel = UILabel(frame: CGRect(x: X, y: BOTTOM(view: slider), width: W/2, height: 21))
            minLabel.text = Q.options[0]
            questionView.addSubview(minLabel)
            
            let maxLabel = UILabel(frame: CGRect(x: X+(W/2), y: BOTTOM(view: slider), width: W/2, height: 21))
            maxLabel.text = Q.options[1]
            maxLabel.textAlignment = .right
            questionView.addSubview(maxLabel)
            
            CHANGE_HEIGHT(view: questionView, BOTTOM(view: minLabel) + (margin*2))
        }
        
        contentView.addSubview(questionView)
        PLACE(sendReponseButton, below: questionView, margin: margin)
        
        currentY += questionView.frame.size.height
        CHANGE_HEIGHT(view: contentView, BOTTOM(view: sendReponseButton) + margin)
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
                (V as! UIButton).isSelected = false
                
                //backgroundColor = COLOR_FROM_HEX("#D9D9D9")
            }
        }

        sender.isSelected = true
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
    
    // Button actions
    @IBAction func sendResponseButtonTap(_ sender: UIButton) {
        
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
                ALERT(title_SUCCES, text_SURVEY_THANKS, viewController: self){
                    var destination: UIViewController?
                    
                    for VC in self.navigationController!.viewControllers {
                        if(VC is ProjectDetailsViewController) {
                            destination = VC
                            break
                        }
                    }
                    
                    if let VC = destination {
                        (VC as! ProjectDetailsViewController).firstTime = true
                        self.navigationController?.popToViewController(VC, animated: true)
                    }
                }
            } else {
                ALERT(title_ERROR, text_GENERIC_ERROR, viewController: self)
            }
            
            self.showLoading(false)
        }
    }
    
    
}
