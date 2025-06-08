import fs from 'fs';
import { fileURLToPath } from 'url';
import path from 'path';

import { SETTINGS_PATH } from '../constants/constants.js';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);
const default_settings = readJson("./default_settings.json", true);

interface ISettings {
    root_folder_list: Array<string>;
}

function readJson(file_path: string, is_relative: boolean = false): any {
    if (is_relative) return JSON.parse(fs.readFileSync(path.join(__dirname, file_path), "utf-8"));
    return JSON.parse(fs.readFileSync(path.resolve(file_path), "utf-8"));
}

export abstract class SettingsManager {
    static inited: boolean = false;
    static settings: ISettings = default_settings;

    static init() {
        this._loadSettings();
        this.inited = true;
    }
    static _loadSettings() {
        if (!fs.existsSync(SETTINGS_PATH)) {
            console.log("Cannot Find settings.json, loading default settings...");
            this.settings = default_settings;
            this.saveSettings();
            return;
        }

        const settings = readJson(SETTINGS_PATH);
        this.settings = settings;
    }

    static getSettings(): ISettings {
        return this.settings;
    }
    static saveSettings() {
        fs.writeFileSync(SETTINGS_PATH, JSON.stringify(this.settings));
    }
}