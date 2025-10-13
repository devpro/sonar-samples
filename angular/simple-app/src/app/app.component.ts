import { Component } from '@angular/core';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css']
})
export class AppComponent {
  title = 'simple-app';
}

unusedFunction() {
  console.log("Cette fonction n'est jamais utilisée ! Test SonarCloud 2 encore !");
}
