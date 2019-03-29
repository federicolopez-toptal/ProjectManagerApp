//
//  SurveyResultsViewController.swift
//  ATKearneyApp
//
//  Created by Federico Lopez on 28/03/2019.
//  Copyright © 2019 Federico Lopez. All rights reserved.
//

import UIKit


struct YesNo {
    var text: String
    var value: Int
}
struct YesNoData {
    var text: String
    var options = [YesNo]()
}


struct Avg {
    var count: Int
    var value: Int
}
struct MultipleData {
    var ATKMember: Avg
    var clients: Avg
}

class SurveyResultsViewController: BaseViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    let BASE_TAG = 200
    
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
        
        buildAnswers()
    }
    
    // MARK: - Button actions
    @IBAction func closeButtonTap(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Answers
    func buildAnswers() {
        let X = descriptionLabel.frame.origin.x
        let W = descriptionLabel.frame.size.width
        
        // No answers yet!
        if(SelectedSurvey.shared.answers.count==0) {
            let noAnswersLabel = UILabel(frame: CGRect(x: X, y: 0, width: W, height: 42))
            noAnswersLabel.font = descriptionLabel.font
            noAnswersLabel.numberOfLines = 2
            noAnswersLabel.textAlignment = .center
            noAnswersLabel.text = "There are no answers for\nyour survey yet!"
            
            contentView.addSubview(noAnswersLabel)
            noAnswersLabel.center = contentView.center
            
            return
        }

        // QUESTION SELECTOR
        var Y = BOTTOM(view: descriptionLabel) + 20.0
        let questionSelector = UIView(frame: CGRect(x: 0, y: Y, width: self.view.frame.width, height: 45))
        //questionSelector.backgroundColor = UIColor.green
        contentView.addSubview(questionSelector)
        
        let qCount = SelectedSurvey.shared.questions.count
        for I in 0...qCount-1 {
            let qButton = UIButton(type: .custom)
            let buttonW = W / CGFloat(qCount)
            qButton.frame = CGRect(x: X + (buttonW*CGFloat(I)) + ((5.0/2) * CGFloat(qCount-1)), y: 0, width: buttonW - 5.0, height: 40)
            qButton.backgroundColor = COLOR_FROM_HEX("#D9D9D9")
            qButton.setTitle("Question \(I+1)", for: .normal)
            qButton.setTitleColor(UIColor.lightGray, for: .normal)
            qButton.setTitleColor(UIColor.black, for: .selected)
            qButton.tag = I
            qButton.addTarget(self, action: #selector(questionSelectorButtonTap), for: .touchUpInside)
            
            questionSelector.addSubview(qButton)
        }
        
        
        
        
        // QUESTIONS + ANSWERS
        for (index, Q) in SelectedSurvey.shared.questions.enumerated() {
            Y = BOTTOM(view: questionSelector) + 30.0
            let questionView = UIView(frame: CGRect(x: 0, y: Y, width: self.view.frame.size.width, height: 10))
            questionView.backgroundColor = UIColor.white
            
            let questionLabel = UILabel(frame: CGRect(x: X, y: 10.0, width: W, height: 10))
            questionLabel.font = descriptionLabel.font
            questionView.addSubview(questionLabel)
            CHANGE_LABEL_HEIGHT(label: questionLabel, text: Q.text)
            
            Y = BOTTOM(view: questionLabel) + 30.0
            if(Q.type == .text) {
                // TEXT
                for A in SelectedSurvey.shared.answers {
                    if let response = A.info[index] as? String {
                        let roleLabel = UILabel(frame: CGRect(x: X, y: Y, width: W, height: 10))
                        roleLabel.font = UIFont.systemFont(ofSize: 10)
                        CHANGE_LABEL_HEIGHT(label: roleLabel, text: "CLIENT")
                        if(A.isATKMember){
                            CHANGE_LABEL_HEIGHT(label: roleLabel, text: "ATK MEMBER")
                        }
                        questionView.addSubview(roleLabel)
                        
                        let answerLabel = UILabel(frame: CGRect(x: X, y: BOTTOM(view: roleLabel), width: W, height: 10))
                        answerLabel.font = descriptionLabel.font
                        CHANGE_LABEL_HEIGHT(label: answerLabel, text: response)
                        questionView.addSubview(answerLabel)
                        print(response)
                        print("")
                        
                        let line = UIView(frame: CGRect(x: X, y: BOTTOM(view: answerLabel) + 15.0, width: W, height: 1.0))
                        line.backgroundColor = COLOR_FROM_HEX("#D9D9D9")
                        questionView.addSubview(line)
                        
                        Y = BOTTOM(view: line) + 20.0
                    }
                }
            } else if(Q.type == .multiple) {
                // MULTIPLE
                for A in SelectedSurvey.shared.answers {
                    if let response = A.info[index] as? Array<String> {
                        let roleLabel = UILabel(frame: CGRect(x: X, y: Y, width: W, height: 10))
                        roleLabel.font = UIFont.systemFont(ofSize: 10)
                        CHANGE_LABEL_HEIGHT(label: roleLabel, text: "CLIENT")
                        if(A.isATKMember){
                            CHANGE_LABEL_HEIGHT(label: roleLabel, text: "ATK MEMBER")
                        }
                        questionView.addSubview(roleLabel)
                        
                        let answerLabel = UILabel(frame: CGRect(x: X, y: BOTTOM(view: roleLabel) + 5.0, width: W, height: 10))
                        answerLabel.font = descriptionLabel.font
                        
                        var responseText = ""
                        for strOption in response {
                            if(!responseText.isEmpty){
                                responseText += "\n"
                            }
                            responseText += "• \(strOption)"
                        }
                        CHANGE_LABEL_HEIGHT(label: answerLabel, text: responseText)
                        questionView.addSubview(answerLabel)
                        
                        let line = UIView(frame: CGRect(x: X, y: BOTTOM(view: answerLabel) + 15.0, width: W, height: 1.0))
                        line.backgroundColor = COLOR_FROM_HEX("#D9D9D9")
                        questionView.addSubview(line)
                        
                        Y = BOTTOM(view: line) + 20.0
                    }
                }
            } else if(Q.type == .yes_no) {
                // YES / NO
                var data = [
                    YesNoData(text: "CLIENT", options: [YesNo(text: Q.options[0], value: 0), YesNo(text: Q.options[1], value: 0)]),
                    YesNoData(text: "ATK MEMBER", options: [YesNo(text: Q.options[0], value: 0), YesNo(text: Q.options[1], value: 0)])
                ]

                for A in SelectedSurvey.shared.answers {
                    if let response = A.info[index] as? String {
                        var I = 0
                        if(A.isATKMember) {
                            I = 1
                        }
                        
                        var J = 0
                        if(response == Q.options[1]) {
                            J = 1
                        }
                        
                        data[I].options[J].value += 1
                    }
                }
                
                for D in data {
                    var text = ""
                    let total = D.options[0].value + D.options[1].value
                    
                    var perc1 = 0
                    if(D.options[0].value>0) {
                        perc1 = (D.options[0].value * 100)/total
                    }
                    var perc2 = 100-perc1
                    
                    if(total==0) {
                        perc1 = 0
                        perc2 = 0
                    }
                    
                    let roleLabel = UILabel(frame: CGRect(x: X, y: Y, width: W, height: 10))
                    roleLabel.font = UIFont.systemFont(ofSize: 10)
                    CHANGE_LABEL_HEIGHT(label: roleLabel, text: D.text)
                    questionView.addSubview(roleLabel)
                    
                    let option1Label = UILabel(frame: CGRect(x: X, y: BOTTOM(view: roleLabel) + 5.0, width: W/2, height: 10))
                    option1Label.font = descriptionLabel.font
                    text = "\(D.options[0].text) - \(perc1)%"
                    CHANGE_LABEL_HEIGHT(label: option1Label, text: text)
                    questionView.addSubview(option1Label)
                    
                    let option2Label = UILabel(frame: CGRect(x: X+(W/2), y: BOTTOM(view: roleLabel) + 5.0, width: W/2, height: 10))
                    option2Label.font = descriptionLabel.font
                    text = "\(D.options[1].text) - \(perc2)%"
                    CHANGE_LABEL_HEIGHT(label: option2Label, text: text)
                    option2Label.textAlignment = .right
                    questionView.addSubview(option2Label)
                    
                    let grayView = UIView(frame: CGRect(x: X, y: BOTTOM(view: option1Label) + 4.0, width: W, height: 35))
                    grayView.backgroundColor = COLOR_FROM_HEX("#D9D9D9")
                    questionView.addSubview(grayView)
                    
                    if(total>0) {
                        let blackView = UIView(frame: CGRect(x: X, y: BOTTOM(view: option1Label) + 4.0, width:W * (CGFloat(perc1)/100), height: 35))
                        blackView.backgroundColor = UIColor.black
                        questionView.addSubview(blackView)
                    }
                    
                    if(total==0) {
                        let noDataLabel = UILabel(frame: CGRect(x: X, y: 0, width: W, height: 10))
                        noDataLabel.textAlignment = .center
                        noDataLabel.font = UIFont.systemFont(ofSize: 12.0)
                        CHANGE_LABEL_HEIGHT(label: noDataLabel, text: "No answers registered")
                        questionView.addSubview(noDataLabel)
                        noDataLabel.center = grayView.center
                    }
                    
                    Y = BOTTOM(view: grayView) + 30.0
                }
            } else if(Q.type == .scale) {
                // MULTIPLE
                var data = MultipleData(ATKMember: Avg(count: 0, value: 0), clients: Avg(count: 0, value: 0))
                
                for A in SelectedSurvey.shared.answers {
                    if let response = A.info[index] as? Int {
                        if(A.isATKMember) {
                            data.ATKMember.count += 1
                            data.ATKMember.value += response
                        } else {
                            data.clients.count += 1
                            data.clients.value += response
                        }
                    }
                }
                
                for I in 1...2 {
                    var roleText = "CLIENT"
                    if(I==2) {
                        roleText = "ATK MEMBER"
                    }
                    
                    var avg = 0
                    if(I==1) {
                        if(data.clients.count>0) {
                            avg = data.clients.value/data.clients.count
                        }
                    } else {
                        if(data.ATKMember.count>0) {
                            avg = data.ATKMember.value/data.ATKMember.count
                        }
                    }
                    
                    let roleLabel = UILabel(frame: CGRect(x: X, y: Y, width: W, height: 10))
                    roleLabel.font = UIFont.systemFont(ofSize: 10)
                    CHANGE_LABEL_HEIGHT(label: roleLabel, text: roleText)
                    questionView.addSubview(roleLabel)
                    
                    let blackView = UIView(frame: CGRect(x: X, y: BOTTOM(view: roleLabel) + 5.0, width: W, height: 35))
                    blackView.backgroundColor = UIColor.black
                    questionView.addSubview(blackView)
                    
                    let valueLabel = UILabel(frame: CGRect(x: X, y: 0, width: W, height: 10))
                    valueLabel.font = UIFont.systemFont(ofSize: 12.0, weight: .bold)
                    valueLabel.textAlignment = .center
                    valueLabel.textColor = UIColor.white
                    CHANGE_LABEL_HEIGHT(label: valueLabel, text: "Average answer: \(avg)")
                    if(avg==0) {
                        CHANGE_LABEL_HEIGHT(label: valueLabel, text: "No answers registered")
                    }
                    questionView.addSubview(valueLabel)
                    valueLabel.center = blackView.center
                    
                    Y = BOTTOM(view: blackView) + 30.0
                }
            }
            
            CHANGE_HEIGHT(view: questionView, Y)
            questionView.tag = BASE_TAG + index
            contentView.addSubview(questionView)
        }
        
        questionSelectorButtonTap(sender: questionSelector.subviews.first as! UIButton)
    }
    
    func showAnswer(_ index: Int) {
        for V in contentView.subviews {
            if(V.tag >= BASE_TAG) {
                V.isHidden = true
            }
        }
        
        let tag = BASE_TAG + index
        let answerView = contentView.viewWithTag(tag)!
        answerView.isHidden = false
        
        CHANGE_HEIGHT(view: contentView, BOTTOM(view: answerView) + 30.0)
        scrollView.contentSize = contentView.frame.size
    }
    
    // MARK: - Some events
    @objc func questionSelectorButtonTap(sender: UIButton) {
        let superView = sender.superview
        
        for V in superView!.subviews {
            if(V is UIButton) {
                let button = (V as! UIButton)
                
                button.isSelected = false
                button.titleLabel?.font = UIFont.systemFont(ofSize: 15.0)
            }
        }
        
        sender.isSelected = true
        sender.titleLabel?.font = UIFont.systemFont(ofSize: 15.0, weight: .bold)
        showAnswer(sender.tag)
    }
    
}
