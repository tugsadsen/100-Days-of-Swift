//
//  ViewController.swift
//  Milestone Projects 7-9
//
//  Created by Tuğşad Şen on 24.03.2022.
//

import UIKit

class ViewController: UIViewController {
    var wordLabel: UILabel!
    var wordCountLabel: UILabel!
    var imageName: String!
    var image: UIImage!
    var imageView: UIImageView!
  //  var imageView: UIImageView!
    
    var words = [String]()
    var usedWords = [String]()
    var lettersUsed = [String]()
    var alphabetButtons = [UIButton]()
    var currentWord = ""
    var wordCount = 0
    var wrongAnswerCount = 0
    
    
  
    
    let alphabet = ["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"]
    
    var labelString = "" {
        didSet {
            wordLabel.text = "\(labelString)"
        }
    }
    var score = 0 {
        didSet {
            title = "Score: \(score)"
        }
    }
        
    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
        title = "Score: \(score)"
        
        wordLabel = UILabel()
        wordLabel.translatesAutoresizingMaskIntoConstraints = false
        wordLabel.textAlignment = .center
        wordLabel.font = UIFont.systemFont(ofSize: 44)
        wordLabel.text = "Word"
        wordLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        view.addSubview(wordLabel)
        
        wordCountLabel = UILabel()
        wordCountLabel.translatesAutoresizingMaskIntoConstraints = false
        wordCountLabel.textAlignment = .right
        wordCountLabel.font = UIFont.systemFont(ofSize: 12)
        wordCountLabel.text = "\(wordCount) letters"
        view.addSubview(wordCountLabel)
        
//        imageView = UIImageView()
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        imageView = UIImageView(named: "hang2.png")
//        view.addSubview(imageView)
        
        imageName = "hang\(wrongAnswerCount).png"
        image = UIImage(named: imageName)
        imageView = UIImageView(image: image!)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        
        
        let buttonsView = UIView()
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonsView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 20),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            
            wordLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 30),
            wordLabel.widthAnchor.constraint(equalTo: imageView.widthAnchor, constant: 0),
            
            wordCountLabel.topAnchor.constraint(equalTo: wordLabel.bottomAnchor),
            wordCountLabel.widthAnchor.constraint(equalTo: wordLabel.widthAnchor,constant: -50),
            
            buttonsView.widthAnchor.constraint(equalToConstant: 720),
            buttonsView.heightAnchor.constraint(equalToConstant: 630),
            buttonsView.topAnchor.constraint(equalTo: wordCountLabel.bottomAnchor, constant: 100),
            buttonsView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 30),
        
        
        ])
        
        let width = 60
        let height = 40
        
        var column = 0
        var row = 0
        
        for idx in 0..<alphabet.count - 1 {
            let letterButton = UIButton(type: .system)
            letterButton.titleLabel?.font = UIFont.systemFont(ofSize: 30)
            letterButton.setTitle("\(alphabet[idx].uppercased())", for: .normal)
            letterButton.addTarget(self, action: #selector(letterTapped), for: .touchUpInside)
            
            if idx % 7 == 0 {
                column = 0
                row += 1
            }
            
            let frame = CGRect(x: column * height, y: row * height, width: width, height: height)
            letterButton.frame = frame
            
            buttonsView.addSubview(letterButton)
            alphabetButtons.append(letterButton)
            
            column += 1
            
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let wordsURL = Bundle.main.url(forResource: "words", withExtension: "txt") {
            if let allWords = try? String(contentsOf: wordsURL) {
                words = allWords.components(separatedBy: "\n")
            }
        }
        
        loadWord()
        
    }
    
    func loadWord() {
        let unusedWords = words.filter { (!usedWords.contains($0)) }
        currentWord = unusedWords.randomElement()!.uppercased()
        
        labelString = String(repeating: "?", count: currentWord.count)
        wordCountLabel.text = "\(currentWord.count) letters"
        
        for button in alphabetButtons {
            button.isHidden = false
        }
    
        lettersUsed.removeAll()
        
        print(currentWord)
    }

    @objc func letterTapped(_ sender: UIButton) {
        guard let buttonTitle = sender.titleLabel?.text else { return }
        
        lettersUsed.append(buttonTitle)
        
        sender.isHidden = true
        
        var tempString = ""
        
        for letter in currentWord {
            if lettersUsed.contains(String(letter)) {
                tempString += String(letter)
            } else {
                tempString  += "?"
                
            }
                
        }
        
        if tempString == labelString {
            wrongAnswerCount += 1
            if wrongAnswerCount == 6 {
                imageView.image = UIImage(named: "hang\(wrongAnswerCount).png")
                let ad = UIAlertController(title: "You lost", message: "The game will be restart", preferredStyle: .alert)
                ad.addAction(UIAlertAction(title: "OK", style: .default))
                wrongAnswerCount = 0
                score -= score != 0 ? 10 : 0
                present(ad, animated: true)
                
                loadWord()
                deneme()
                //imageView.image = UIImage(named: "hang\(wrongAnswerCount).png")
                //ddgdsdhs osdhhskjgskhkjssdgsdasgdsgdsdsdsd
            } else {
            errorMessage(title: "", message: "The letter you pressed is not in the word")
            score -= score != 0 ? 10 : 0
            imageView.image = UIImage(named: "hang\(wrongAnswerCount).png")
            }
            
        } else {
            labelString = tempString
            score += 10
        }
        
        if labelString.contains("?") != true {
            errorMessage(title: "Congratz!", message: "Next level!")
            wrongAnswerCount = 0
            loadWord()
        }
        
        
    }
    
    func errorMessage(title: String, message: String) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        self.present(ac, animated: true,completion: nil)
        
        let when = DispatchTime.now() + 1
        DispatchQueue.main.asyncAfter(deadline: when) {
            ac.dismiss(animated: true, completion: nil)
        }
    }
    
    func deneme() {
        let when = DispatchTime.now() + 2
        DispatchQueue.main.asyncAfter(deadline: when){
            self.imageView.image = UIImage(named: "hang\(self.wrongAnswerCount).png")
        }
    }
       
}

