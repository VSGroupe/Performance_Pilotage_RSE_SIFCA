import 'dart:convert';
import 'package:http/http.dart' as http;

class SendMailController {
  static const baseUrl = "https://api-send-mail-mvxl.onrender.com";

  Future<bool> sendMail(String mail, String userPassword) async {
    const String apiUrl = "$baseUrl/send-mail";

    const String siteUrl = "https://performace-rse-sifca.web.app/";

    String htmlMessage = """
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Roboto:wght@400;500;700&display=swap');

        body {
            font-family: 'Roboto', sans-serif;
            background-color: #f4f4f4;
            margin: 0;
            padding: 0;
            color: #333;
        }
        .container {
            background-color: #ffffff;
            padding: 20px;
            margin: 10px;
            border-radius: 5px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }
        h1 {
            color: #4CAF50;
            text-align: center;
            font-weight: 700;
        }
        p {
            line-height: 1.6;
        }
        .link-text {
            color: #1E90FF;
            text-decoration: none;
        }
        .link-text:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Votre compte a été créé avec succès</h1>
        <p>Votre mot de passe pour accéder à la plateforme est: <strong>$userPassword</strong></p>
        <p>Cliquez sur ce lien pour accéder à la plateforme : <strong><a href="$siteUrl" class="link-text">Performance RSE SIFCA</a></strong></p>
        <p>Merci de changer votre mot de passe après la première connexion.</p>
    </div>
</body>
</html>


    """;

    final Map<String, dynamic> data = {
      "subject":
          "Connexion à la plateforme PERFORMANCE RSE SIFCA: Mot de passe",
      "recipient": mail,
      "message": htmlMessage,
    };

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
