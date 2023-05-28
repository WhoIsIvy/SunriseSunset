//
//  ViewController.swift
//  SunriseSunset
//
//  Created by Lisa Fellows on 5/26/23.
//

import UIKit

class ViewController: UIViewController {
    private var backgroundImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    private var sunriseStackView: UIStackView =  {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        return stackView
    }()

    private var sunriseLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.adjustsFontSizeToFitWidth = true
        return label
    }()

    private var sunriseSpacerView = UIView()

    private var sunsetStackView: UIStackView =  {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        return stackView
    }()

    private var sunsetSpacerView = UIView()

    private var sunsetLabel: UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        return label
    }()

    private var textField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 5
        textField.textAlignment = .center
        return textField
    }()

    private var additionalInfoLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        return label
    }()

    private var timeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        return stackView
    }()

    private var sunriseTimeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        return label
    }()

    private var sunsetTimeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        return label
    }()

    private var spacerView = UIView()

    private var disclaimerLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        return label
    }()

    private let viewModel = ViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupSubviews()
        setupConstraints()
        setupViewModelCallbacks()
    }

    private func setupView() {
        view.backgroundColor = .white
        backgroundImageView.image = UIImage(named: viewModel.backgroundImage)

        sunriseLabel.attributedText = viewModel.sunriseTitle
        sunsetLabel.attributedText = viewModel.sunsetTitle

        textField.placeholder = viewModel.zipPlaceholder
        textField.delegate = self

        disclaimerLabel.attributedText = viewModel.disclaimerAttributed
    }

    private func setupSubviews() {
        sunriseStackView.addArrangedSubview(sunriseLabel)
        sunriseStackView.addArrangedSubview(sunriseSpacerView)

        sunsetStackView.addArrangedSubview(sunsetSpacerView)
        sunsetStackView.addArrangedSubview(sunsetLabel)

        timeStackView.addArrangedSubview(sunriseTimeLabel)
        timeStackView.addArrangedSubview(sunsetTimeLabel)

        [backgroundImageView,
         sunriseStackView,
         sunsetStackView,
         textField,
         additionalInfoLabel,
         timeStackView,
         spacerView,
         disclaimerLabel].forEach {
            view.addSubview($0)
        }
    }

    private func setupConstraints() {
        [backgroundImageView,
         sunriseStackView,
         sunsetStackView,
         textField,
         additionalInfoLabel,
         timeStackView,
         spacerView,
         disclaimerLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        let safe = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            sunriseStackView.heightAnchor.constraint(equalToConstant: 35),
            sunriseStackView.topAnchor.constraint(equalTo: safe.topAnchor, constant: 16),
            sunriseStackView.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: 16),
            sunriseStackView.trailingAnchor.constraint(equalTo: safe.trailingAnchor, constant: -16),

            sunsetStackView.heightAnchor.constraint(equalToConstant: 35),
            sunsetStackView.topAnchor.constraint(equalTo: sunriseStackView.bottomAnchor, constant: 16),
            sunsetStackView.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: 16),
            sunsetStackView.trailingAnchor.constraint(equalTo: safe.trailingAnchor, constant: -16),

            textField.heightAnchor.constraint(equalToConstant: 35),
            textField.topAnchor.constraint(equalTo: sunsetLabel.bottomAnchor, constant: 16),
            textField.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: safe.trailingAnchor, constant: -16),

            additionalInfoLabel.heightAnchor.constraint(equalToConstant: 35),
            additionalInfoLabel.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 8),
            additionalInfoLabel.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: 16),
            additionalInfoLabel.trailingAnchor.constraint(equalTo: safe.trailingAnchor, constant: -16),

            timeStackView.topAnchor.constraint(equalTo: additionalInfoLabel.bottomAnchor, constant: 16),
            timeStackView.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: 16),
            timeStackView.trailingAnchor.constraint(equalTo: safe.trailingAnchor, constant: -16),

            spacerView.topAnchor.constraint(equalTo: timeStackView.bottomAnchor),
            spacerView.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            spacerView.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            spacerView.bottomAnchor.constraint(equalTo: disclaimerLabel.topAnchor),

            disclaimerLabel.heightAnchor.constraint(equalToConstant: 50),
            disclaimerLabel.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: 16),
            disclaimerLabel.trailingAnchor.constraint(equalTo: safe.trailingAnchor, constant: -16),
            disclaimerLabel.bottomAnchor.constraint(equalTo: safe.bottomAnchor, constant: -16)
        ])
    }

    private func setupViewModelCallbacks() {
        viewModel.displayInvalidZipCodeAlert = { [weak self] attributedAlert in
            self?.additionalInfoLabel.attributedText = attributedAlert
        }
    }

    private func displayErrorAlert(_ error: CustomError) {
        let alert = UIAlertController(
            title: error.title,
            message: error.description,
            preferredStyle: .alert
        )

        let action = UIAlertAction(title: .init(localizationKey: .ok), style: .cancel) { [weak self] action in
            self?.textField.becomeFirstResponder()
        }

        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }

    private func updateSunInfo(from sunModel: SunModel) {
        additionalInfoLabel.attributedText = viewModel.attributed(
            for: sunModel.cityAndCountry,
            ofType: .additionalInfo
        )
        
        sunriseTimeLabel.attributedText = viewModel.attributed(
            for: sunModel.sunriseTime,
            ofType: .sunTime
        )
        
        sunsetTimeLabel.attributedText = viewModel.attributed(
            for: sunModel.sunsetTime,
            ofType: .sunTime
        )
    }
}

// MARK: TextFieldDelegate
extension ViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        additionalInfoLabel.text?.removeAll()
        sunriseTimeLabel.text?.removeAll()
        sunsetTimeLabel.text?.removeAll()
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        let zipString = textField.text ?? String()
        viewModel.retrieveSunTimes(for: zipString) { [weak self] sunModel, customError in
            guard let self = self, let sunModel = sunModel, customError == nil else {
                self?.displayErrorAlert(customError ?? .unknown)
                return
            }

            self.updateSunInfo(from: sunModel)
        }
    }
}
