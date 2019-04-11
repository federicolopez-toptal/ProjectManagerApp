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


struct MultipleOption {
    var text: String
    var count: Int
}
struct MultipleData {
    var text: String
    var options = [MultipleOption]()
}

struct Avg {
    var count: Int
    var value: Int
}
struct ScaleData {
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
    var isActive = true
    
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
    
    @IBAction func manageButtonTap(_ sender: UIButton) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        if(isActive) {
            let finishAction = UIAlertAction(title: "Finish survey", style: .default) { (alertAction) in
                self.finishSurvey()
            }
            alert.addAction(finishAction)
        }
        
        let deleteAction = UIAlertAction(title: "Delete survey", style: .default) { (alertAction) in
            self.deleteSurvey()
        }
        alert.addAction(deleteAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true) {
        }
    }
    
    
    // MARK: - Answers
    func buildAnswers() {
        let X = descriptionLabel.frame.origin.x
        let W = descriptionLabel.frame.size.width
        
        // No answers yet!
        if(SelectedSurvey.shared.answers.count==0) {
            let resultLabel = UILabel(frame: CGRect(x: X, y: BOTTOM(view: descriptionLabel) + 25, width: W, height: 10))
            resultLabel.font = UIFont(name: "Graphik-Medium", size: 16)
            contentView.addSubview(resultLabel)
            CHANGE_LABEL_HEIGHT(label: resultLabel, text: "Survey results")
            
            let line = UIView(frame: CGRect(x: X, y: BOTTOM(view: resultLabel)+20.0, width: W, height: 1))
            line.backgroundColor = UIColor.black.withAlphaComponent(0.1)
            contentView.addSubview(line)
            
            let imageView = UIImageView(frame: CGRect(x: (contentView.frame.width - 36)/2,
                                                      y: 380, width: 36, height: 40))
            imageView.image = UIImage(named: "survey.png")
            contentView.addSubview(imageView)
            
            let noDataLabel = UILabel(frame: CGRect(x: X, y: BOTTOM(view: imageView) + 16, width: W, height: 10))
            noDataLabel.font = UIFont(name: "Graphik-Regular", size: 16)
            noDataLabel.numberOfLines = 2
            noDataLabel.textAlignment = .center
            CHANGE_LABEL_HEIGHT(label: noDataLabel, text: "There are no answers\nfor this survey yet!")
            contentView.addSubview(noDataLabel)
            
            return
        }

        // QUESTION SELECTOR
        var Y = BOTTOM(view: descriptionLabel) + 30.0
        let questionSelector = UIView(frame: CGRect(x: 25, y: Y, width: W, height: 50))
        questionSelector.backgroundColor = UIColor.white
        questionSelector.layer.borderColor = COLOR_FROM_HEX("#DBD8D8").cgColor
        questionSelector.layer.borderWidth = 1.0
        contentView.addSubview(questionSelector)
        
        let qCount = SelectedSurvey.shared.questions.count
        for I in 0...qCount-1 {
            let qButton = UIButton(type: .custom)
            let buttonW = W / CGFloat(qCount)
            qButton.frame = CGRect(x: buttonW*CGFloat(I), y: 0, width: buttonW, height: 50)
            qButton.backgroundColor = UIColor.clear
            qButton.setTitle("QUESTION \(I+1)", for: .normal)
            qButton.setTitleColor(UIColor.black.withAlphaComponent(0.5), for: .normal)
            qButton.setTitleColor(UIColor.black.withAlphaComponent(0.8), for: .selected)
            qButton.titleLabel?.font = UIFont(name: "Graphik-Semibold", size: 13)
            qButton.tag = I
            qButton.addTarget(self, action: #selector(questionSelectorButtonTap), for: .touchUpInside)
            
            questionSelector.addSubview(qButton)
        }
        if(qCount==2) {
            let middleView = UIView(frame: CGRect(x: questionSelector.frame.width/2, y: 15, width: 1, height: 20))
            middleView.backgroundColor = COLOR_FROM_HEX("#DBD8D8")
            questionSelector.addSubview(middleView)
        }
        
        
        
        
        // QUESTIONS + ANSWERS
        for (index, Q) in SelectedSurvey.shared.questions.enumerated() {
            Y = BOTTOM(view: questionSelector) + 30.0
            let questionView = UIView(frame: CGRect(x: 0, y: Y, width: self.view.frame.size.width, height: 10))
            questionView.backgroundColor = UIColor.white
            
            let questionLabel = UILabel(frame: CGRect(x: X, y: 10.0, width: W, height: 10))
            questionLabel.font = UIFont(name: "Graphik-Medium", size: 16)
            questionView.addSubview(questionLabel)
            CHANGE_LABEL_HEIGHT(label: questionLabel, text: Q.text)
            
            let line = UIView(frame: CGRect(x: X, y: BOTTOM(view: questionLabel)+20.0, width: W, height: 1))
            line.backgroundColor = UIColor.black.withAlphaComponent(0.1)
            questionView.addSubview(line)
            
            Y = BOTTOM(view: line) + 20.0
            if(Q.type == .text) {
                // TEXT
                for A in SelectedSurvey.shared.answers {
                    if let response = A.info[index] as? String {
                        let roleLabel = UILabel(frame: CGRect(x: X, y: Y, width: W, height: 10))
                        roleLabel.font = UIFont(name: "Graphik-Medium", size: 10)
                        
                        if(A.isATKMember){
                            CHANGE_LABEL_HEIGHT(label: roleLabel, text: "ATK MEMBER")
                            roleLabel.textColor = COLOR_FROM_HEX("#BC1832")
                        } else {
                            CHANGE_LABEL_HEIGHT(label: roleLabel, text: "CLIENT")
                            roleLabel.textColor = UIColor.black.withAlphaComponent(0.5)
                        }
                        questionView.addSubview(roleLabel)
                        
                        let answerLabel = UILabel(frame: CGRect(x: X, y: BOTTOM(view: roleLabel) + 10.0, width: W, height: 10))
                        answerLabel.font = UIFont(name: "Graphik-Regular", size: 16)
                        CHANGE_LABEL_HEIGHT(label: answerLabel, text: response)
                        questionView.addSubview(answerLabel)
                        
                        let line = UIView(frame: CGRect(x: X, y: BOTTOM(view: answerLabel) + 20.0, width: W, height: 1))
                        line.backgroundColor = UIColor.black.withAlphaComponent(0.1)
                        questionView.addSubview(line)
                        
                        Y = BOTTOM(view: line) + 20.0
                    }
                }
            } else if(Q.type == .multiple) {
                // MULTIPLE options
                var data = [MultipleData]()
                
                for i in 1...2 {
                    var text = "CLIENT"
                    if(i==2) {
                        text = "ATK MEMBER"
                    }
                    
                    var options = [MultipleOption]()
                    for strOption in Q.options {
                        options.append( MultipleOption(text: strOption, count: 0) )
                    }
                    
                    data.append(MultipleData(text: text, options: options))
                }
                
                for A in SelectedSurvey.shared.answers {
                    var i = 0
                    if(A.isATKMember) {
                        i = 1
                    }
                    
                    for response in A.info[index] as! [String] {
                        for (j, O) in data[i].options.enumerated() {
                            if(O.text == response){
                                data[i].options[j].count += 1
                                break
                            }
                        }
                    }
                }
                
                
                
                for (i, D) in data.enumerated() {
                    let roleLabel = UILabel(frame: CGRect(x: X, y: Y, width: W, height: 10))
                    roleLabel.font = UIFont(name: "Graphik-Medium", size: 10)
                    CHANGE_LABEL_HEIGHT(label: roleLabel, text: D.text)
                    if(i==0) {
                        roleLabel.textColor = UIColor.black.withAlphaComponent(0.5)
                    } else {
                        roleLabel.textColor = COLOR_FROM_HEX("#BC1832")
                    }
                    questionView.addSubview(roleLabel)
                    
                    var valY = BOTTOM(view: roleLabel) + 15.0
                    for O in data[i].options {
                        let optionView = UIView(frame: CGRect(x: X, y: valY, width: W, height: 45))
                        optionView.backgroundColor = UIColor.white
                        optionView.layer.borderColor = COLOR_FROM_HEX("#DBD8D8").cgColor
                        optionView.layer.borderWidth = 1.0
                        
                        let optionLabel = UILabel(frame: CGRect(x: 0, y: 1, width: W, height: 10))
                        optionLabel.font = UIFont(name: "Graphik-Medium", size: 17)
                        CHANGE_LABEL_HEIGHT(label: optionLabel, text: O.text.uppercased())
                        optionView.addSubview(optionLabel)
                        
                        var mFrame = optionLabel.frame
                        mFrame.origin.x =  10.0
                        mFrame.origin.y = (optionView.frame.height - mFrame.height)/2
                        optionLabel.frame = mFrame
                        
                        
                        
                        
                        let countLabel = UILabel(frame: CGRect(x: 0, y: 1, width: W - 10.0, height: 10))
                        countLabel.font = UIFont(name: "Graphik-Medium", size: 17)
                        CHANGE_LABEL_HEIGHT(label: countLabel, text: String(O.count) )
                        countLabel.textAlignment = .right
                        optionView.addSubview(countLabel)
                        
                        mFrame = countLabel.frame
                        mFrame.origin.y = (optionView.frame.height - mFrame.height)/2
                        countLabel.frame = mFrame
                        
                        
                        
                        questionView.addSubview(optionView)
                        valY += 45 + 10.0
                    }
                    
                    Y = valY + 30.0
                }
                
                
                
                

                
                /*
                 Prev version
                 
                for A in SelectedSurvey.shared.answers {
                    if let response = A.info[index] as? Array<String> {
                        let roleLabel = UILabel(frame: CGRect(x: X, y: Y, width: W, height: 10))
                        roleLabel.font = UIFont.systemFont(ofSize: 10)
                        
                        if(A.isATKMember){
                            CHANGE_LABEL_HEIGHT(label: roleLabel, text: "ATK MEMBER")
                            roleLabel.textColor = COLOR_FROM_HEX("#BC1832")
                        } else {
                            CHANGE_LABEL_HEIGHT(label: roleLabel, text: "CLIENT")
                            roleLabel.textColor = UIColor.black.withAlphaComponent(0.5)
                        }
                        questionView.addSubview(roleLabel)
                        
                        var valY = BOTTOM(view: roleLabel) + 15.0
                        for strOption in response {
                            let optionView = UIView(frame: CGRect(x: X, y: valY, width: W, height: 45))
                            optionView.backgroundColor = UIColor.white
                            optionView.layer.borderColor = COLOR_FROM_HEX("#DBD8D8").cgColor
                            optionView.layer.borderWidth = 1.0
                            
                            let optionLabel = UILabel(frame: CGRect(x: 0, y: 1, width: W, height: 10))
                            optionLabel.font = UIFont(name: "Graphik-Medium", size: 17)
                            CHANGE_LABEL_HEIGHT(label: optionLabel, text: strOption.uppercased())
                            optionView.addSubview(optionLabel)
                            
                            var mFrame = optionLabel.frame
                            mFrame.origin.x =  10.0
                            mFrame.origin.y = (optionView.frame.height - mFrame.height)/2
                            optionLabel.frame = mFrame
                            
                            questionView.addSubview(optionView)
                            valY += 45 + 10.0
                        }
                        
                        
                        Y = valY + 30.0
                    }
                }
 */
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
                
                for (i, D) in data.enumerated() {
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
                    roleLabel.font = UIFont(name: "Graphik-Medium", size: 10)
                    CHANGE_LABEL_HEIGHT(label: roleLabel, text: D.text)
                    if(i==0) {
                        roleLabel.textColor = UIColor.black.withAlphaComponent(0.5)
                    } else {
                        roleLabel.textColor = COLOR_FROM_HEX("#BC1832")
                    }
                    questionView.addSubview(roleLabel)
                    
                    let option1Label = UILabel(frame: CGRect(x: X, y: BOTTOM(view: roleLabel) + 20.0, width: W/2, height: 10))
                    option1Label.font = UIFont(name: "Graphik-Medium", size: 18)
                    option1Label.textColor = UIColor.black
                    text = "\(D.options[0].text) - \(perc1)%"
                    CHANGE_LABEL_HEIGHT(label: option1Label, text: text)
                    questionView.addSubview(option1Label)
                    
                    let option2Label = UILabel(frame: CGRect(x: X+(W/2), y: BOTTOM(view: roleLabel) + 20.0, width: W/2, height: 10))
                    option2Label.font = UIFont(name: "Graphik-Medium", size: 18)
                    option2Label.textColor = UIColor.black.withAlphaComponent(0.7)
                    text = "\(D.options[1].text) - \(perc2)%"
                    CHANGE_LABEL_HEIGHT(label: option2Label, text: text)
                    option2Label.textAlignment = .right
                    questionView.addSubview(option2Label)
                    
                    let grayView = UIView(frame: CGRect(x: X, y: BOTTOM(view: option1Label) + 15.0, width: W, height: 55))
                    grayView.backgroundColor = COLOR_FROM_HEX("#F5F5F5")
                    questionView.addSubview(grayView)
                    
                    if(total>0) {
                        let blackView = UIView(frame: CGRect(x: X, y: BOTTOM(view: option1Label) + 15.0, width:W * (CGFloat(perc1)/100), height: 55))
                        blackView.backgroundColor = UIColor.black
                        questionView.addSubview(blackView)
                    }
                    
                    if(total==0) {
                        let noDataLabel = UILabel(frame: CGRect(x: X, y: 0, width: W, height: 10))
                        noDataLabel.textAlignment = .center
                        noDataLabel.font = UIFont(name: "Graphik-Medium", size: 16)
                        CHANGE_LABEL_HEIGHT(label: noDataLabel, text: "No answers registered")
                        questionView.addSubview(noDataLabel)
                        noDataLabel.center = grayView.center
                    }
                    
                    Y = BOTTOM(view: grayView) + 30.0
                }
            } else if(Q.type == .scale) {
                // SCALE
                var data = ScaleData(ATKMember: Avg(count: 0, value: 0), clients: Avg(count: 0, value: 0))
                
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
                    roleLabel.font = UIFont(name: "Graphik-Medium", size: 10)
                    CHANGE_LABEL_HEIGHT(label: roleLabel, text: roleText)
                    if(I==1) {
                        roleLabel.textColor = UIColor.black.withAlphaComponent(0.5)
                    } else {
                        roleLabel.textColor = COLOR_FROM_HEX("#BC1832")
                    }
                    questionView.addSubview(roleLabel)
                    
                    let blackView = UIView(frame: CGRect(x: X, y: BOTTOM(view: roleLabel) + 20.0, width: W, height: 55))
                    blackView.backgroundColor = UIColor.black
                    questionView.addSubview(blackView)
                    
                    let valueLabel = UILabel(frame: CGRect(x: X, y: 0, width: W, height: 10))
                    valueLabel.font = UIFont(name: "Graphik-Medium", size: 14)
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
                //button.titleLabel?.font = UIFont.systemFont(ofSize: 15.0)
            }
        }
        
        sender.isSelected = true
        //sender.titleLabel?.font = UIFont.systemFont(ofSize: 15.0, weight: .bold)
        showAnswer(sender.tag)
    }
    
    // MARK: - Some actions
    func finishSurvey() {
        let title = "Finish survey"
        let msg = "The users will not be able to answer it anymore. Confirm?"
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        
        let yesAction = UIAlertAction(title: "Yes", style: .default) { (alertAction) in
            self.finishSurvey_step2()
        }
        alert.addAction(yesAction)
        
        let noAction = UIAlertAction(title: "No", style: .default) { (alertAction) in
            print("No")
        }
        alert.addAction(noAction)
        
        self.present(alert, animated: true) {
        }
    }
    func finishSurvey_step2() {
        showLoading(true)
        FirebaseManager.shared.finishSurvey(surveyID: SelectedSurvey.shared.surveyID) { (error) in
            if(error==nil) {
                ALERT(title_SUCCES, text_SURVEY_FINISHED, viewController: self) {
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
    
    
    
    func deleteSurvey() {
        let title = "Delete survey"
        let msg = "The survey and all it results will be deleted. Confirm?"
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        
        let yesAction = UIAlertAction(title: "Yes", style: .default) { (alertAction) in
            self.deleteSurvey_step2()
        }
        alert.addAction(yesAction)
        
        let noAction = UIAlertAction(title: "No", style: .default) { (alertAction) in
            print("No")
        }
        alert.addAction(noAction)
        
        self.present(alert, animated: true) {
        }
    }
    func deleteSurvey_step2() {
        let S = SelectedSurvey.shared.surveyID
        let P = SelectedProject.shared.projectID
        
        showLoading(true)
        FirebaseManager.shared.deleteSurvey(surveyID: S, projectID: P){ (error) in
            if(error==nil) {
                ALERT(title_SUCCES, text_SURVEY_DELETED, viewController: self) {
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
