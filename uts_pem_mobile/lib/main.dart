import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const QuizApp());
}

class QuizApp extends StatelessWidget {
  const QuizApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        textTheme: GoogleFonts.poppinsTextTheme().apply(
          bodyColor: Colors.white,
          displayColor: Colors.white,
        ),
      ),
      home: const MenuPage(),
    );
  }
}

// Menu Page
class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Selamat Datang")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/logo.png',
                width: 200,
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const QuizPage()),
                  );
                },
                child: const Text("Mulai Kuis"),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () {
                  SystemNavigator.pop();
                },
                child: const Text("Keluar"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  final List<Map<String, dynamic>> questions = [
    {
      'question': 'Apa perbedaan utama antara D3 dan D4 dalam pendidikan vokasi?',
      'options': [
        'D4 memiliki lebih banyak liburan',
        'D4 berdurasi 4 tahun dan setara sarjana terapan',
        'D3 memiliki lebih banyak tugas',
        'D3 lebih fokus pada teori'
      ],
      'answer': 1
    },
    {
      'question': 'Apa itu Manajemen Informatika?',
      'options': [
        'Studi tentang manajemen keuangan',
        'Ilmu yang mempelajari pengelolaan sistem informasi dan teknologi',
        'Cabang ilmu kedokteran',
        'Pengembangan perangkat keras komputer'
      ],
      'answer': 1
    },
    {
      'question': 'Apa nama bahasa pemrograman yang paling umum digunakan untuk pengembangan web?',
      'options': ['Python', 'C++', 'JavaScript', 'Kotlin'],
      'answer': 2
    },
    {
      'question': 'Dalam pengembangan sistem informasi, tahap pertama yang harus dilakukan adalah?',
      'options': ['Pengujian sistem', 'Implementasi', 'Pemrograman', 'Analisis kebutuhan'],
      'answer': 3
    },
    {
      'question': 'Apa singkatan dari HTML?',
      'options': [
        'HyperText Markup Language',
        'HighText Machine Language',
        'HyperTool Markup Link',
        'HyperText Management Language'
      ],
      'answer': 0
    },
    {
      'question': 'Salah satu tugas utama dari seorang analisis sistem adalah?',
      'options': [
        'Mengurus keuangan perusahaan',
        'Menganalisis kebutuhan merancang sistem informasi',
        'Menjual perangkat lunak',
        'Memproduksi perangkat keras'
      ],
      'answer': 1
    },
    {
      'question': 'Apa itu database?',
      'options': [
        'Perangkat keras komputer',
        'Bahasa pemrograman',
        'Kumpulan data yang terorganisir dan dapat diakses elektronik',
        'Aplikasi desain grafis'
      ],
      'answer': 2
    },
    {
      'question': 'Aplikasi apa yang sering digunakan mahasiswa untuk membuat presentasi?',
      'options': ['Adobe Photoshop', 'Noteopad++', 'Visual Studio Code', 'Microsoft PowerPoint'],
      'answer': 3
    },
    {
      'question': 'Apa kepanjangan dari SQL dalam database?',
      'options': ['Secure Query Language', 'Software Query Line', 'Syntax Query List', 'Structured Query Language'],
      'answer': 3
    },
    {
      'question': 'Apa yang dimaksud dengan Debugging dalam pemrograman?',
      'options': ['Menambahkan fitur baru', 'Mencari dan memperbaiki kesalahan dalam kode', 'Menulis ulang seluruh programan', 'Membuat desain aplikasi'],
      'answer': 1
    },
  ];

  int currentQuestion = 0;
  int score = 0;
  int timeLeft = 90;
  List<int?> selectedAnswers = [];
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timeLeft > 0) {
        setState(() => timeLeft--);
      } else {
        timer.cancel();
        nextQuestion();
      }
    });
  }

  void nextQuestion() {
    if (currentQuestion < questions.length - 1) {
      setState(() {
        currentQuestion++;
        timeLeft = 90;
      });
    } else {
      _timer?.cancel();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ResultPage(
            score: score,
            questions: questions,
            selectedAnswers: selectedAnswers,
          ),
        ),
      );
    }
  }

  void selectAnswer(int index) {
    setState(() {
      selectedAnswers.length = currentQuestion + 1;
      selectedAnswers[currentQuestion] = index;
      if (index == questions[currentQuestion]['answer']) {
        score += 10;
      }
    });
    nextQuestion();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quiz Manajemen Informatika')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Pertanyaan ${currentQuestion + 1} dari ${questions.length}',
                  style: GoogleFonts.poppins(fontSize: 18)),
              const SizedBox(height: 10),
              SizedBox(
                width: 200,
                child: LinearProgressIndicator(
                  value: (currentQuestion + 1) / questions.length,
                  backgroundColor: Colors.grey[700],
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
                ),
              ),
              const SizedBox(height: 10),
              Text('Sisa Waktu: $timeLeft detik',
                  style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  questions[currentQuestion]['question'],
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20),
              ...List.generate(questions[currentQuestion]['options'].length, (index) {
                return GestureDetector(
                  onTap: () => selectAnswer(index),
                  child: Card(
                    color: Colors.blueGrey[700],
                    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text(
                        questions[currentQuestion]['options'][index],
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(fontSize: 18),
                      ),
                    ),
                  ),
                );
              }),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

class ResultPage extends StatelessWidget {
  final int score;
  final List<Map<String, dynamic>> questions;
  final List<int?> selectedAnswers;

  const ResultPage({
    super.key,
    required this.score,
    required this.questions,
    required this.selectedAnswers,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hasil Kuis')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              'Skor Akhir: $score / ${questions.length * 10}',
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: questions.length,
              itemBuilder: (context, index) {
                final question = questions[index];
                final userAnswer = selectedAnswers[index];
                final correctAnswer = question['answer'];

                return Card(
                  color: Colors.grey[900],
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Q${index + 1}: ${question['question']}',
                            style: GoogleFonts.poppins(
                                fontSize: 16, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 10),
                        ...List.generate(question['options'].length, (i) {
                          Color optionColor;
                          if (i == correctAnswer && i == userAnswer) {
                            optionColor = Colors.green;
                          } else if (i == userAnswer && i != correctAnswer) {
                            optionColor = Colors.red;
                          } else if (i == correctAnswer) {
                            optionColor = Colors.green.withOpacity(0.5);
                          } else {
                            optionColor = Colors.transparent;
                          }

                          return Container(
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: optionColor,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.white24),
                            ),
                            child: Text(
                              question['options'][i],
                              style: GoogleFonts.poppins(fontSize: 14),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                );
              },
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const QuizPage()),
              ),
              child: const Text('Coba Lagi'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const MenuPage()),
                );
              },
              child: const Text("Kembali ke Menu"),
            ),
          ],
        ),
      ),
    );
  }
}
