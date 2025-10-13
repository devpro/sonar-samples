import { Component } from '@angular/core';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css']
})
export class AppComponent {
  title = 'simple-app';
  
  // Code smell 1: Variable inutilisée
  private unusedVariable = 'This variable is never used';
  
  // Code smell 2: Fonction avec trop de complexité cyclomatique
  processData(input: any): any {
    if (input) {
      if (input.type === 'A') {
        if (input.value > 100) {
          if (input.status === 'active') {
            if (input.category === 'premium') {
              return input.value * 1.5;
            } else {
              return input.value * 1.2;
            }
          } else {
            return input.value * 0.8;
          }
        } else {
          return input.value;
        }
      } else if (input.type === 'B') {
        if (input.value > 50) {
          return input.value * 2;
        } else {
          return input.value * 1.5;
        }
      } else {
        return 0;
      }
    } else {
      return null;
    }
  }
  
  // Code smell 3: Fonction dupliquée (similaire à processData)
  calculateValue(data: any): any {
    if (data) {
      if (data.type === 'A') {
        if (data.value > 100) {
          if (data.status === 'active') {
            if (data.category === 'premium') {
              return data.value * 1.5;
            } else {
              return data.value * 1.2;
            }
          } else {
            return data.value * 0.8;
          }
        } else {
          return data.value;
        }
      } else if (data.type === 'B') {
        if (data.value > 50) {
          return data.value * 2;
        } else {
          return data.value * 1.5;
        }
      } else {
        return 0;
      }
    } else {
      return null;
    }
  }
  
  // Code smell 4: Console.log oublié (mauvaise pratique en production)
  debugFunction() {
    console.log('Debug information that should not be in production');
  }
  
  // Code smell 5: Fonction trop longue et variables mal nommées
  doSomething() {
    var a = 1; // var au lieu de let/const
    var b = 2;
    var c = 3;
    var d = 4;
    var e = 5;
    var f = 6;
    var g = 7;
    var h = 8;
    var i = 9;
    var j = 10;
    
    // Beaucoup de code répétitif
    if (a == 1) { // == au lieu de ===
      console.log('a is 1');
    }
    if (b == 2) {
      console.log('b is 2');
    }
    if (c == 3) {
      console.log('c is 3');
    }
    if (d == 4) {
      console.log('d is 4');
    }
    if (e == 5) {
      console.log('e is 5');
    }
  }
}
