import fs from 'fs';
import { SettingsManager } from "../settings/settings_manager.js"
import path from 'path';
import { IMAGE_FILE_EXTENSIONS } from '../constants/constants.js';

enum FileTypes {
    Image,
    JSON,
    Others,
}
interface FileObject {
    file_name: string,
    file_type: FileTypes
}
interface FolderObject {
    parent: string,
    folder_name: string,
    folder_path: string,
    objects: Array<FolderObject | FileObject>,
}

export abstract class FolderManager {
    static _root_folder_paths: Array<string> = [];
    static _root_folder_map: Map<string, string> = new Map();
    static _folder_list: Array<FolderObject> = [];

    static init() {
        if (!SettingsManager.inited) throw new Error("FolderManager.init() is called before SettingsManager is initialized!");

        // 1. Load root folders
        const settings = SettingsManager.getSettings();
        this._root_folder_paths = settings.root_folder_list;

        // 2. Travel into folders recursively
        this._folder_list = [{
            parent: "",
            folder_name: "/",
            folder_path: "/",
            objects: [],
        }];
        for (const folder_path of this._root_folder_paths) {
            if (!fs.existsSync(folder_path)) this._throwError(`Root Folder '${folder_path}' does not exist!`);
            
            const folder_name = folder_path.split("/").at(-1) ?? "";
            this._folder_list[0].objects.push({
                parent: "/",
                folder_name: folder_name,
                folder_path: `$${folder_name}$`,
                objects: [],
            });
            this._root_folder_map.set(folder_name, folder_path);

            const folders = this._traverseFolder("/", `$${folder_name}$`, true);
            this._folder_list = this._folder_list.concat(folders);
        }
    }

    static getFolder(folder_path: string): FolderObject | void {
        return this._folder_list.find((folder) => folder.folder_path === folder_path);
    }

    /**
     * Turns a shortened file path into an actual file path.
     * (e.g. /$Download$/folder => /home/username/Download/folder)
     * @param file_path - The shortened file path
     * @returns The actual file path.
     */
    static _getActualPath(file_path: string): string {
        const splited = file_path.split("$");
        if (splited.length !== 3) this._throwError(`Error occur while translating path '${file_path}' at _getActualPath().`);
        splited[1] = this._root_folder_map.get(splited[1]) ?? "unknown";
        return splited.join("");
    }
    /**
     * Checks file type based on file extension.
     * @param file_name - name of the file (e.g. aaa.jpg)
     * @returns file type of the file.
     */
    static _getFileType(file_name: string): FileTypes {
        if (file_name.endsWith(".json")) return FileTypes.JSON;
        for (const extension of IMAGE_FILE_EXTENSIONS) {
            if (file_name.endsWith(extension)) return FileTypes.Image;
        }
        return FileTypes.Others;
    }
    /**
     * Traverse through a folder and returns an array of FolderObject of the folder.
     * @param parent - parent folder of the folder_path
     * @param folder_path - the path of the folder to be traversed
     * @param recursive - If the folder should be traversed recursively
     * @returns An array of FolderObject.
     */
    static _traverseFolder(parent: string, folder_path: string, recursive: boolean): Array<FolderObject> {
        const actual_folder_path = this._getActualPath(folder_path);
        const obj_list = fs.readdirSync(actual_folder_path);
        const folder: FolderObject = {
            parent: parent,
            folder_name: folder_path.split("/").at(-1) ?? "Error",
            folder_path: folder_path,
            objects: [],
        };
        const folders = [folder];

        for (const obj of obj_list) {
            const obj_path = `${folder_path}/${obj}`;
            const actual_obj_path = `${actual_folder_path}/${obj}`;

            const is_dir = fs.lstatSync(actual_obj_path).isDirectory();
            if (is_dir) {
                const folder_obj: FolderObject = {
                    parent: folder_path,
                    folder_name: obj,
                    folder_path: obj_path,
                    objects: [],
                }
                folder.objects.push(folder_obj);
                if (recursive) {
                    folders.push(...this._traverseFolder(folder_path, obj_path, true));
                } else {
                    folders.push(folder_obj)
                }
            } else {
                folder.objects.push({
                    file_name: obj,
                    file_type: this._getFileType(obj),
                });
            }
        }
        return folders;
    }

    static _throwError(error_text: string) {
        throw new Error(`${error_text} (In FolderManager)`);
    }
}