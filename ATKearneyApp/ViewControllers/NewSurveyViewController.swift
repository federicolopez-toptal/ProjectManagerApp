//
//  NewSurveyViewController.swift
//  ATKearneyApp
//
//  Created by Federico Lopez on 25/03/2019.
//  Copyright © 2019 Federico Lopez. All rights reserved.
//

import UIKit

class NewSurveyViewController: BaseViewController, UITextViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var questionsSelector: UISegmentedControl!
    @IBOutlet weak var questionTextView: UITextView!
    @IBOutlet weak var responseTypeButton: UIButton!
    @IBOutlet weak var nextStepButton: UIButton!
    
    @IBOutlet weak var yesNoView: UIView!
    @IBOutlet weak var multipleView: UIView!
    @IBOutlet weak var addAnotherView: UIView!
    
    
    
    private var currentQuestion = 0
    
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        SelectedSurvey.shared.reset()
        
        //scrollView.subviews.first!.backgroundColor = UIColor.white
        addFormBehavior(scrollview: scrollView, bottomContraint: bottomConstraint)
        addAnotherView.backgroundColor = UIColor.white
        
        placeSettingsView(yesNoView)
        placeSettingsView(multipleView)
        multipleView.clipsToBounds = true
    }
    func placeSettingsView(_ view: UIView) {
        var mFrame = view.frame
        mFrame.origin.y = responseTypeButton.frame.origin.y + responseTypeButton.frame.size.height + 30.0
        view.frame = mFrame
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        titleTextField.text = SelectedSurvey.shared.title
        descriptionTextView.text = SelectedSurvey.shared.description
        
        refreshQuestionsSelector()
        refreshQuestion()
    }
    
    
    // MARK: - Questions
    func refreshQuestionsSelector() {
        questionsSelector.removeAllSegments()
        for (index, _) in SelectedSurvey.shared.questions.enumerated() {
            questionsSelector.insertSegment(withTitle: "Question \(index+1)", at: index, animated: false)
        }
    }
    
    func refreshQuestion() {
        let Q = SelectedSurvey.shared.questions[currentQuestion]
        
        questionsSelector.selectedSegmentIndex = currentQuestion
        questionTextView.text = Q.text
        
        switch Q.type {
        case .yes_no:
            responseTypeButton.setTitle("Response type: Yes/No", for: .normal)
            placeNextButtonBelow(view: yesNoView)
            fill_yesNoFieldsWithQuestion(Q)
            yesNoView.isHidden = false
            multipleView.isHidden = true
        case .multiple:
            responseTypeButton.setTitle("Response type: Multiple options", for: .normal)
            fill_multipleFieldsWithQuestion(Q)
            placeNextButtonBelow(view: multipleView)
            yesNoView.isHidden = true
            multipleView.isHidden = false
        case .scale:
            responseTypeButton.setTitle("Response type: Scale", for: .normal)
            yesNoView.isHidden = true
            multipleView.isHidden = true
        default: // Text
            responseTypeButton.setTitle("Response type: Text", for: .normal)
            placeNextButtonBelow(view: responseTypeButton)
            yesNoView.isHidden = true
            multipleView.isHidden = true
        }
    }
    func placeNextButtonBelow(view: UIView) {
        let margin: CGFloat = 30.0
        var mFrame = nextStepButton.frame
        
        mFrame.origin.y = view.frame.origin.y + view.frame.size.height + margin
        nextStepButton.frame = mFrame
        
        contentView.frame = CGRect(x: 0, y: 0, width: scrollView.frame.size.width,
                                   height: nextStepButton.frame.origin.y + nextStepButton.frame.height + margin)
        
        scrollView.contentSize = contentView.frame.size
    }
    
    func fill_yesNoFieldsWithQuestion(_ question: Question) {
        for (index, value) in question.settings.enumerated() {
            (yesNoView.subviews[index] as! UITextField).text = value
        }
    }
    func fill_multipleFieldsWithQuestion(_ question: Question) {
        for (index, value) in question.settings.enumerated() {
            (multipleView.subviews[index] as! UITextField).text = value
        }
        
        let view = multipleView.subviews[question.settings.count-1]
        
        var mFrame = addAnotherView.frame
        mFrame.origin.y = view.frame.origin.y + view.frame.size.height
        addAnotherView.frame = mFrame
        addAnotherView.superview?.bringSubviewToFront(addAnotherView)
        
        if(SelectedSurvey.shared.questions[currentQuestion].settings.count==5) {
            mFrame = multipleView.frame
            mFrame.size.height = view.frame.origin.y + view.frame.size.height
            multipleView.frame = mFrame
            addAnotherView.isHidden = true
        } else {
            mFrame = multipleView.frame
            mFrame.size.height = addAnotherView.frame.origin.y + addAnotherView.frame.size.height
            multipleView.frame = mFrame
            addAnotherView.isHidden = false
        }
    }
    
    
    // MARK: - Button actions
    @IBAction func closeButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func responseTypeButtonTap(_ sender: UIButton) {
        let text = "Select response type"
        let alert = UIAlertController(title: nil, message: text, preferredStyle: .actionSheet)
        
        let textAction = UIAlertAction(title: "Text", style: .default) { (alertAction) in
            self.changeResponseTypeTo(.text)
        }
        let yesNoAction = UIAlertAction(title: "Yes/No", style: .default) { (alertAction) in
            self.changeResponseTypeTo(.yes_no)
        }
        let multipleAction = UIAlertAction(title: "Multiple options", style: .default) { (alertAction) in
            self.changeResponseTypeTo(.multiple)
        }
        let scaleAction = UIAlertAction(title: "Scale", style: .default) { (alertAction) in
            self.changeResponseTypeTo(.scale)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(textAction)
        alert.addAction(yesNoAction)
        alert.addAction(multipleAction)
        alert.addAction(scaleAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true) {
        }
    }
    func changeResponseTypeTo(_ type: Question.QuestionType) {
        SelectedSurvey.shared.questions[currentQuestion].type = type
        
        if(type == .yes_no) {
            SelectedSurvey.shared.questions[currentQuestion].settings = ["Yes", "No"]
        } else if(type == .multiple) {
            SelectedSurvey.shared.questions[currentQuestion].settings = ["First option", "Second option"]
        }
        
        refreshQuestion()
    }
    
    @IBAction func newQuestionButtonTap(_ sender: UIButton) {
        if(SelectedSurvey.shared.questions.count<SURVEYS_MAX_QUESTIONS) {
            let newQuestion = Question(text: "", type: .text, settings: [])
            SelectedSurvey.shared.questions.append(newQuestion)
            
            currentQuestion = SelectedSurvey.shared.questions.count-1
            refreshQuestionsSelector()
            refreshQuestion()
        } else {
            ALERT(title_ERROR, text_MAX_QUESTIONS, viewController: self)
        }
    }
    
    @IBAction func addAnotherButtonTap(_ sender: UIButton) {
        let count = SelectedSurvey.shared.questions[currentQuestion].settings.count+1
        
        var text = "Third option"
        if(count==4) {
            text = "Fourth option"
        } else if(count==5) {
            text = "Fifth option"
        }
        
        SelectedSurvey.shared.questions[currentQuestion].settings.append(text)
        refreshQuestion()
    }
    
    @IBAction func deleteActionButtonTap(_ sender: UIButton) {
        SelectedSurvey.shared.questions[currentQuestion].settings.remove(at: sender.tag)
        refreshQuestion()
    }
    
    @IBAction func deleteQuestionButtonTap(_ sender: UIButton) {
        if(SelectedSurvey.shared.questions.count>1) {
            SelectedSurvey.shared.questions.remove(at: currentQuestion)
            currentQuestion -= 1
            refreshQuestionsSelector()
            refreshQuestion()
        }
    }
    
    
    
    // MARK: - Other events
    @IBAction func questionsSelectorValueChanged(_ sender: UISegmentedControl) {
        currentQuestion = sender.selectedSegmentIndex
        refreshQuestion()
    }
    
    // UITextView
    func textViewDidChange(_ textView: UITextView) {
        SelectedSurvey.shared.questions[currentQuestion].text = textView.text
    }
    
    @IBAction func textFieldsChanged(_ sender: UITextField) {
        if(sender.superview==yesNoView) {
            SelectedSurvey.shared.questions[currentQuestion].settings[sender.tag] = sender.text!
        } else if(sender.superview==multipleView) {
            SelectedSurvey.shared.questions[currentQuestion].settings[sender.tag] = sender.text!
        }
    }
    
    
    
}
