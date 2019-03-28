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
    @IBOutlet weak var multipleOptionsView: UIView!
    @IBOutlet weak var addAnotherOptionView: UIView!
    @IBOutlet weak var scaleView: UIView!
    
    
    
    private var currentQuestion = 0
    
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        SelectedSurvey.shared.reset()
        
        scrollView.subviews.first!.backgroundColor = UIColor.white
        addFormBehavior(scrollview: scrollView, bottomContraint: bottomConstraint)
        addAnotherOptionView.backgroundColor = UIColor.white
        
        placeSettingsView(yesNoView)
        placeSettingsView(multipleOptionsView)
        placeSettingsView(scaleView)
        multipleOptionsView.clipsToBounds = true
        
        /*
        descriptionTextView.placeholder = "Description (Optional)"
        questionTextView.placeholder = "Type your question (required)"
 */
    }
    func placeSettingsView(_ view: UIView) {
        var mFrame = view.frame
        mFrame.origin.y = responseTypeButton.frame.origin.y + responseTypeButton.frame.size.height + 40.0
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
            responseTypeButton.setTitle("Type: Yes/No", for: .normal)
            placeNextButtonBelow(view: yesNoView)
            fill_yesNoFieldsWithQuestion(Q)
            yesNoView.isHidden = false
            multipleOptionsView.isHidden = true
            scaleView.isHidden = true
        case .multiple:
            responseTypeButton.setTitle("Type: Multiple options", for: .normal)
            fill_multipleFieldsWithQuestion(Q)
            placeNextButtonBelow(view: multipleOptionsView)
            yesNoView.isHidden = true
            multipleOptionsView.isHidden = false
            scaleView.isHidden = true
        case .scale:
            responseTypeButton.setTitle("Type: Scale", for: .normal)
            fill_scaleFieldsWithQuestion(Q)
            placeNextButtonBelow(view: scaleView)
            yesNoView.isHidden = true
            multipleOptionsView.isHidden = true
            scaleView.isHidden = false
        default: // Text
            responseTypeButton.setTitle("Type: Text", for: .normal)
            placeNextButtonBelow(view: responseTypeButton)
            yesNoView.isHidden = true
            multipleOptionsView.isHidden = true
            scaleView.isHidden = true
        }
    }
    func placeNextButtonBelow(view: UIView) {
        let margin: CGFloat = 60.0
        var mFrame = nextStepButton.frame
        
        mFrame.origin.y = view.frame.origin.y + view.frame.size.height + margin
        nextStepButton.frame = mFrame
        
        contentView.frame = CGRect(x: 0, y: 0, width: scrollView.frame.size.width,
                                   height: nextStepButton.frame.origin.y + nextStepButton.frame.height + margin)
        
        scrollView.contentSize = contentView.frame.size

    }
    
    func fill_yesNoFieldsWithQuestion(_ question: Question) {
        for (index, value) in question.options.enumerated() {
            (yesNoView.subviews[index] as! UITextField).text = value
        }
    }
    func fill_multipleFieldsWithQuestion(_ question: Question) {
        for (index, value) in question.options.enumerated() {
            (multipleOptionsView.subviews[index] as! UITextField).text = value
        }
        
        let view = multipleOptionsView.subviews[question.options.count-1]
        
        var mFrame = addAnotherOptionView.frame
        mFrame.origin.y = view.frame.origin.y + view.frame.size.height
        addAnotherOptionView.frame = mFrame
        addAnotherOptionView.superview?.bringSubviewToFront(addAnotherOptionView)
        
        if(SelectedSurvey.shared.questions[currentQuestion].options.count==5) {
            mFrame = multipleOptionsView.frame
            mFrame.size.height = view.frame.origin.y + view.frame.size.height
            multipleOptionsView.frame = mFrame
            addAnotherOptionView.isHidden = true
        } else {
            mFrame = multipleOptionsView.frame
            mFrame.size.height = addAnotherOptionView.frame.origin.y + addAnotherOptionView.frame.size.height
            multipleOptionsView.frame = mFrame
            addAnotherOptionView.isHidden = false
        }
    }
    func fill_scaleFieldsWithQuestion(_ question: Question) {
        for (index, value) in question.options.enumerated() {
            (scaleView.subviews[index] as! UITextField).text = value
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
        
        if(type == .text) {
            SelectedSurvey.shared.questions[currentQuestion].options = []
        } else if(type == .yes_no) {
            SelectedSurvey.shared.questions[currentQuestion].options = ["Yes", "No"]
        } else if(type == .multiple) {
            SelectedSurvey.shared.questions[currentQuestion].options = ["First option", "Second option"]
        } else if(type == .scale) {
            SelectedSurvey.shared.questions[currentQuestion].options = ["Minimum", "Maximum"]
        }
        
        refreshQuestion()
    }
    
    @IBAction func newQuestionButtonTap(_ sender: UIButton) {
        if(SelectedSurvey.shared.questions.count<SURVEYS_MAX_QUESTIONS) {
            let newQuestion = Question(text: "", type: .text, options: [])
            SelectedSurvey.shared.questions.append(newQuestion)
            
            currentQuestion = SelectedSurvey.shared.questions.count-1
            refreshQuestionsSelector()
            refreshQuestion()
        } else {
            ALERT(title_ERROR, text_QUESTIONS_LIMIT, viewController: self)
        }
    }
    
    @IBAction func addAnotherOptionButtonTap(_ sender: UIButton) {
        let count = SelectedSurvey.shared.questions[currentQuestion].options.count+1
        
        var text = "Third option"
        if(count==4) {
            text = "Fourth option"
        } else if(count==5) {
            text = "Fifth option"
        }
        
        SelectedSurvey.shared.questions[currentQuestion].options.append(text)
        refreshQuestion()
    }
    
    @IBAction func deleteActionButtonTap(_ sender: UIButton) {
        SelectedSurvey.shared.questions[currentQuestion].options.remove(at: sender.tag)
        refreshQuestion()
    }
    
    @IBAction func deleteQuestionButtonTap(_ sender: UIButton) {
        if(SelectedSurvey.shared.questions.count>1) {
            SelectedSurvey.shared.questions.remove(at: currentQuestion)
            currentQuestion -= 1
            refreshQuestionsSelector()
            refreshQuestion()
        } else {
            ALERT(title_ERROR, text_QUESTIONS_MIN, viewController: self)
        }
    }
    
    @IBAction func nextButtonTap(_ sender: UIButton) {
        // Validations
        if(titleTextField.text!.isEmpty) {
            ALERT(title_ERROR, text_SURVEY_TITLE, viewController: self)
            return
        }
        
        
        // Questions text should not be empty
        var found = false
        for (index, Q) in SelectedSurvey.shared.questions.enumerated() {
            if(Q.text.isEmpty) {
                ALERT("Question \(index+1)", text_EMPTY_FIELDS, viewController: self)
                found = true
                break
            }
        }
        if(found) {
            return
        }
        
        
        // Question options should not be empty
        found = false
        for (index, Q) in SelectedSurvey.shared.questions.enumerated() {
            for S in Q.options {
                if(S.isEmpty) {
                    ALERT("Question \(index+1)", text_EMPTY_FIELDS, viewController: self)
                    found = true
                    break
                }
            }
            if(found) {
                break
            }
        }
        if(found) {
            return
        }
        
        SelectedSurvey.shared.title = titleTextField.text!
        SelectedSurvey.shared.description = descriptionTextView.text
        
        self.performSegue(withIdentifier: "gotoUsers", sender: self)
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
            SelectedSurvey.shared.questions[currentQuestion].options[sender.tag] = sender.text!
        } else if(sender.superview==multipleOptionsView) {
            SelectedSurvey.shared.questions[currentQuestion].options[sender.tag] = sender.text!
        }
    }
    
    
    
}
