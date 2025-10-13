import { enableProdMode } from '@angular/core';
import { platformBrowserDynamic } from '@angular/platform-browser-dynamic';

import { AppModule } from './app/app.module';
import { environment } from './environments/environment';

if (environment.production) {
  enableProdMode();
}

// Code smell: Variable inutilisée
let unusedVariable = 'Cette variable n\'est jamais utilisée';

platformBrowserDynamic().bootstrapModule(AppModule)
  .catch(err => console.error(err));
