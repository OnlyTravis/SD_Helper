import dotenv from 'dotenv';
import { startApp } from './app.js';
import { SettingsManager } from './code/settings/settings_manager.js';
import { FolderManager } from './code/folders/folder_manager.js';

declare module "express-session" {
    interface SessionData {
        logged_in: boolean,
    }
}

function main() {
    dotenv.config()
    SettingsManager.init();
    FolderManager.init();
    startApp();
}

main();