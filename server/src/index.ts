import dotenv from 'dotenv';
import { startApp } from './app.js';
import { SettingsManager } from './code/settings/settings_manager.js';
import { FolderManager } from './code/folders/folder_manager.js';
import { initEnv } from './code/env/env.js';

async function main() {
    await initEnv();
    SettingsManager.init();
    FolderManager.init();
    startApp();
}

main();