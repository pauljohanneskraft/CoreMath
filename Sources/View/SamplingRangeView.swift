//
//  SamplingRangeView.swift
//  Math
//
//  Created by Paul Kraft on 09.12.17.
//  Copyright © 2017 pauljohanneskraft. All rights reserved.
//

import Cocoa

protocol SamplingRangeViewDelegate: AnyObject {
    func samplingRangeView(_ view: SamplingRangeView, didChange range: SamplingRange?)
}

class SamplingRangeView: NSStackView {
    let startTextField = NSTextField()
    let endTextField = NSTextField()
    let countTextField = NSTextField()
    weak var samplingRangeViewDelegate: SamplingRangeViewDelegate?
    
    init(frame frameRect: NSRect = .zero, range: SamplingRange? = nil) {
        super.init(frame: frameRect)
        setup()
        self.range = range
    }
    
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
        setup()
    }
    
    func setup() {
        setDelegates()
        setupViews()
    }
    
    private func setDelegates() {
        startTextField.delegate = self
        endTextField.delegate = self
        countTextField.delegate = self
        startTextField.focusRingType = .none
        endTextField.focusRingType = .none
        countTextField.focusRingType = .none
    }
    
    private func setupViews() {
        orientation = .horizontal
        alignment = .width
        distribution = .fillEqually
        
        addArrangedSubviewsWithoutResizingMask([
            NSStackView(orientation: .horizontal, alignment: .width, distribution: .fill, subviews: [
                NSTextField(string: "start:", textColor: .white), startTextField
            ]),
            NSStackView(orientation: .horizontal, alignment: .width, distribution: .fill, subviews: [
                NSTextField(string: "end:", textColor: .white), endTextField
            ]),
            NSStackView(orientation: .horizontal, alignment: .width, distribution: .fill, subviews: [
                NSTextField(string: "count:", textColor: .white), countTextField
            ])
        ])
    }
    
    var range: SamplingRange? {
        get {
            guard let start = Double(startTextField.stringValue),
                let end = Double(endTextField.stringValue),
                let count = Int(countTextField.stringValue)
                else { return nil }
            return SamplingRange(start: start, end: end, count: count)
        }
        set {
            startTextField.stringValue = newValue?.start.reducedDescription ?? ""
            endTextField  .stringValue = newValue?.end  .reducedDescription ?? ""
            countTextField.stringValue = newValue?.count.reducedDescription ?? ""
        }
    }
}

extension SamplingRangeView: NSTextFieldDelegate {
    override func controlTextDidEndEditing(_ obj: Notification) {
        samplingRangeViewDelegate?.samplingRangeView(self, didChange: self.range)
    }
}
