//
//  QuizViewController.swift
//  SampleQuiz2
//
//  Created by 廣田航大 on 2022/08/23.
//

import UIKit

class QuizViewController: UIViewController {
    @IBOutlet weak var quizNumberLabel: UILabel!
    @IBOutlet weak var quizTextView: UITextView!
    @IBOutlet weak var answerButton1: UIButton!
    @IBOutlet weak var answerButton2: UIButton!
    @IBOutlet weak var answerButton3: UIButton!
    @IBOutlet weak var answerButton4: UIButton!
    @IBOutlet weak var judgeImageView: UIImageView!
    //csvArrayという配列を用意
    var csvArray: [String] = []
    //クイズ1問分の配列の箱を作る
    var quizArray: [String] = []
    //問題数をカウントする変数
    var quizCount = 0
    //正解数をカウントする
    var correctCount = 0
    //どのレベルを選択したのか
    var selectLebel = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("選択したのはレベル\(selectLebel)")
        //csvファイルから配列にしたコードを画面を表示した時よんでいく→複数のcsvファイルから選択したレベルのcsvファイルを取得する
        csvArray = loadCSV(fileName: "quiz\(selectLebel)")
        print("🟥シャッフル前\(csvArray)\n")
        //csvArrayをシャッフルする
        csvArray.shuffle()
        print("🟩シャッフル後\(csvArray)")
        print(csvArray)
        //quizArrayという配列に問題データの1問分だけ代入
        quizArray = csvArray[quizCount].components(separatedBy: ",")
        //オブジェクトに問題データを読み込む
        quizNumberLabel.text = "第\(quizCount + 1)問"
        quizTextView.text = quizArray[0]
        answerButton1.setTitle(quizArray[2], for:  .normal)
        answerButton2.setTitle(quizArray[3], for:  .normal)
        answerButton3.setTitle(quizArray[4], for:  .normal)
        answerButton4.setTitle(quizArray[5], for:  .normal)
        
        answerButton1.layer.borderWidth = 2
        answerButton1.layer.borderColor = UIColor.black.cgColor
        answerButton2.layer.borderWidth = 2
        answerButton2.layer.borderColor = UIColor.black.cgColor
        answerButton3.layer.borderWidth = 2
        answerButton3.layer.borderColor = UIColor.black.cgColor
        answerButton4.layer.borderWidth = 2
        answerButton4.layer.borderColor = UIColor.black.cgColor
        
        // Do any additional setup after loading the view.
    }
    //QuizViewControllerで数えた正解数をScpreViewControllerで表示する
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let scoreVC = segue.destination as! ScoreViewController
        scoreVC.correct = correctCount
    }
    
    @IBAction func btnAction(sender: UIButton) {
        //ボタンを押したときのタグとcsvArrayの番号を比較して正誤判定を行う
        if sender.tag == Int(quizArray[1]) {
             print("正解")
            correctCount += 1
            judgeImageView.image = UIImage(named: "correct")
        } else {
            print("不正解")
            judgeImageView.image = UIImage(named: "incorrect")
        }
        
        print("スコア：\(correctCount)")
        judgeImageView.isHidden = false
        answerButton1.isEnabled = false
        answerButton2.isEnabled = false
        answerButton3.isEnabled = false
        answerButton4.isEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.judgeImageView.isHidden = true
            self.answerButton1.isEnabled = true
            self.answerButton2.isEnabled = true
            self.answerButton3.isEnabled = true
            self.answerButton4.isEnabled = true
            //セットしたボックスを呼ぶ
            self.nextQuiz()
        }
    }
    //次の問題をセット
    func nextQuiz() {
        quizCount += 1
        //ボタンを置いたらかつ、次の問題がない場合画面を遷移する
        if quizCount < csvArray.count {
            quizArray = csvArray[quizCount].components(separatedBy: ",")
            quizNumberLabel.text = "第\(quizCount + 1)問"
            quizTextView.text = quizArray[0]
            answerButton1.setTitle(quizArray[2], for:  .normal)
            answerButton2.setTitle(quizArray[3], for:  .normal)
            answerButton3.setTitle(quizArray[4], for:  .normal)
            answerButton4.setTitle(quizArray[5], for:  .normal)
        } else {
            performSegue(withIdentifier: "toScoreVC", sender: nil)
        }
    }
    //csvファイルの問題データを読み込んで配列にする
    func loadCSV(fileName: String) -> [String] {
        let csvBundle = Bundle.main.path(forResource: fileName, ofType: "csv")!
        do {
            let csvDate = try String(contentsOfFile: csvBundle, encoding: String.Encoding.utf8)
            let lineChange = csvDate.replacingOccurrences(of: "\r", with: "‘n")
            csvArray = lineChange.components(separatedBy: "\n")
            csvArray.removeLast()
        } catch {
            print("エラー")
        }
        return csvArray
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
