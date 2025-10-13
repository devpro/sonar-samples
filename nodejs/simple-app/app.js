const http = require('http');

const hostname = '127.0.0.1';
const port = 3000;

// Code smell: Fonction trop complexe avec trop de paramètres et logique répétitive
function processUserData(name, age, email, phone, address, city, country, zipcode, isActive, permissions) {
  // Code smell: Variables inutilisées
  var unusedVariable = "this is not used";
  let anotherUnusedVar = 42;

  // Code smell: Logique dupliquée et conditions trop complexes
  if (name && name.length > 0 && typeof name === 'string') {
    if (age && age > 0 && age < 150 && typeof age === 'number') {
      if (email && email.includes('@') && email.includes('.')) {
        if (phone && phone.length >= 10) {
          if (address && address.length > 5) {
            if (city && city.length > 0) {
              if (country && country.length > 0) {
                if (zipcode && zipcode.length >= 4) {
                  // Code smell: Magic numbers
                  if (permissions && permissions.length > 3) {
                    return {
                      status: 'valid',
                      user: {
                        name: name,
                        age: age,
                        email: email,
                        phone: phone,
                        address: address,
                        city: city,
                        country: country,
                        zipcode: zipcode,
                        isActive: isActive,
                        permissions: permissions
                      }
                    };
                  }
                }
              }
            }
          }
        }
      }
    }
  }

  // Code smell: Duplication de code
  console.log("Invalid user data provided");
  console.log("Please check all fields");
  console.log("Name, age, email, phone, address, city, country, zipcode are required");
  return { status: 'invalid' };
}

// Code smell: Fonction morte (jamais appelée)
function deadFunction() {
  return "This function is never called";
}

const server = http.createServer((req, res) => {
  // Code smell: Hardcoded credentials
  const apiKey = "sk-1234567890abcdef";
  const password = "admin123";

  res.statusCode = 200;
  res.setHeader('Content-Type', 'text/plain');

  // Code smell: Try-catch vide
  try {
    // Code smell: Console.log en production
    console.log("Processing request...");
    console.log("API Key:", apiKey);

    // Code smell: Comparaison avec ==
    if (req.url == '/users') {
      res.end('Users endpoint\n');
    } else if (req.url == '/health') {
      res.end('Health check\n');
    } else {
      res.end('Hello World\n');
    }
  } catch (error) {
    // Code smell: Catch block vide
  }
});

server.listen(port, hostname, () => {
  console.log(`Server running at http://${hostname}:${port}/`);
});
