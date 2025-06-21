import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';
import { SettingsManager } from "../settings/settings_manager.js"
import { ALLOWED_FILE_TYPES, IMAGE_FILE_EXTENSIONS, TEMP_FOLDER_PATH } from '../constants/constants.js';
import { FileTypes, FileObject, FolderObject } from './folder_enums.js';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

export abstract class FolderManager {
    static _root_folder_paths: Array<string> = [];
    static _root_folder_map: Map<string, string> = new Map();
    static _folder_list: Array<FolderObject> = [];
    static _tmp_folder_path: String = "";

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
            folders: [],
            files: []
        }];
        for (const folder_path of this._root_folder_paths) {
            if (!fs.existsSync(folder_path)) this._throwError(`Root Folder '${folder_path}' does not exist!`);
            
            const folder_name = folder_path.split("/").at(-1) ?? "";
            this._folder_list[0].folders.push({
                parent: "/",
                folder_name: folder_name,
                folder_path: `$${folder_name}$`,
                folders: [],
                files: []
            });
            this._root_folder_map.set(folder_name, folder_path);

            const folders = this._traverseFolder("/", `$${folder_name}$`, true);
            this._folder_list = this._folder_list.concat(folders);
        }

        // 3. Get tmp folder path
        this._tmp_folder_path = TEMP_FOLDER_PATH;
    }

    static getFolder(folder_path: string): FolderObject | void {
        return this._folder_list.find((folder) => folder.folder_path === folder_path);
    }
    static getNameFromPath(path: string): string {
        return path.split("/").at(-1) ?? "";
    }
    static getParentFromPath(path: string): string {
        const splitted = path.split("/");
        return splitted.slice(0, splitted.length-1).join("/");
    }

    static fileExist(file_path: string): boolean {
        const path_length = file_path.length;
        const file_name = file_path.split("/").at(-1) ?? "";
        const folder_path = file_path.substring(0, path_length-file_name.length-1);

        const folder = this.getFolder(folder_path);
        if (!folder) return false;

        const file = folder.files.find((f) => f.file_name === file_name);
        if (!file) return false;

        const actual_path = this.getActualPath(file_path);
        if (!fs.existsSync(actual_path)) {
            console.log(`Error: A file exists in FolderManager but is not present in file system!\nFile: ${file_path} | ${actual_path}`);
            return false;
        }
        return true;
    }
    static folderExist(folder_path: string): boolean {
        return (this._folder_list.findIndex((folder) => folder.folder_path === folder_path) != -1);
    }

    static moveFile(file_path: string, to_folder_path: string): boolean {
        return false;
    }
    static renameFile(file_path: string, new_name: string): boolean {
        try {
            // 1. Get original file index
            const path_length = file_path.length;
            const file_name = file_path.split("/").at(-1)!;
            const folder_path = file_path.substring(0, path_length-file_name.length-1);
            const file_extension = file_name.split(".").at(-1)!;

            const folder = this.getFolder(folder_path);
            if (!folder) return false;

            const index = folder.files.findIndex((f) => f.file_name === file_name);
            if (index === -1) return false;

            // 2. Check if new name is taken
            const new_path = `${folder_path}/${new_name}.${file_extension}`;
            if (FolderManager.fileExist(new_path)) return false;
            const actual_old_path = this.getActualPath(file_path);
            const actual_new_path = this.getActualPath(new_path);
        
            fs.renameSync(actual_old_path, actual_new_path);
            folder.files[index].file_name = `${new_name}.${file_extension}`;
            return true;
        } catch (error) {
            console.log(`An error occured when renaming a file! Error: ${error}`);
            return false;
        }
    }
    static renameFiles(file_paths: Array<string>, new_names: Array<string>): boolean {
        // 1. Check if files are from same folder
        const file_names = file_paths.map((file_path) => file_path.split("/").at(-1) ?? "");
        new_names = new_names.map((new_name, i) => `${new_name}.${file_paths[i].split(".").at(-1) ?? ""}`);
        const folder_path = file_paths[0].substring(0, file_paths[0].length - file_names[0].length - 1);

        for (let i = 0; i < file_paths.length; i++) {
            if (file_paths[i].startsWith(folder_path) && file_paths[i].length === folder_path.length + file_names[i].length + 1) continue;
            return false;
        }
        
        // 2. Check new file names conflicts with other files in folder
        const folder = this.getFolder(folder_path);
        if (!folder) return false;

        const file_indices = [];
        for (const file_name of file_names) {
            const index = folder.files.findIndex((f) => f.file_name === file_name);
            if (index === -1) return false;
            file_indices.push(index);
        }

        for (let i = 0; i < folder.files.length; i++) {
            if (file_indices.includes(i)) continue;
            if (new_names.includes(folder.files[i].file_name)) return false;
        }
        
        // 3. Check if all files exists in file system
        const actual_file_paths = file_paths.map((file_path) => this.getActualPath(file_path));
        for (const actual_file_path of actual_file_paths) {
            if (!fs.existsSync(actual_file_path)) return false;
        }
        
        // 4. Move files to temp folder
        const actual_folder_path = this.getActualPath(folder_path);
        for (let i = 0; i < file_paths.length; i++) {
            fs.renameSync(actual_file_paths[i], `${this._tmp_folder_path}/${file_names[i]}`);
        }
        
        // 5. Rename & Move files back 
        for (let i = 0; i < file_paths.length; i++) {
            fs.renameSync(`${this._tmp_folder_path}/${file_names[i]}`, `${actual_folder_path}/${new_names[i]}`);
        }
        
        // 6. Rename files in folder object
        for (let i = 0; i < file_paths.length; i++) {
            const index = file_indices[i];
            folder.files[index].file_name = new_names[i];
        }
        return true;
    }
    static renameFolder(folder_path: string, new_name: string): boolean {
        const folder = this.getFolder(folder_path);
        if (!folder) return false;
        
        const old_folder_name = this.getNameFromPath(folder_path);
        const new_folder_path = `${folder_path.substring(0, folder_path.length - old_folder_name.length)}${new_name}`;
        if (this.getFolder(new_folder_path)) return false;

        const actual_old_path = this.getActualPath(folder_path);
        const actual_new_path = this.getActualPath(new_folder_path);
        if (fs.existsSync(actual_new_path) || !fs.existsSync(actual_old_path)) return false;
        fs.renameSync(actual_old_path, actual_new_path);
        folder.folder_name = new_name;
        folder.folder_path = new_folder_path;
        for (const inner_folder of folder.folders) {
            inner_folder.parent = new_folder_path;
        }

        return true;
    }
    static deleteFile(file_path: string): boolean {
        const path_length = file_path.length;
        const file_name = file_path.split("/").at(-1) ?? "";
        const folder_path = file_path.substring(0, path_length-file_name.length-1);

        const folder = this.getFolder(folder_path);
        if (!folder) return false;

        const index = folder.files.findIndex((f) => f.file_name === file_name);
        if (index === -1) return false;

        const actual_path = this.getActualPath(file_path);
        try {
            fs.rmSync(actual_path);
            folder.files.splice(index, 1);
            return true;
        } catch (err) {
            console.log(`An error occured when deleting a file!\n Deleting : ${file_path} | ${actual_path}.\n Error: ${err}`);
            return false;
        }
    }
    static deleteFolder(folder_path: string): boolean {
        const index = this._folder_list.findIndex((folder) => folder.folder_path === folder_path);
        if (index === -1) return false;

        const actual_path = this.getActualPath(folder_path);
        const parent_path = this.getParentFromPath(folder_path);
        try {
            fs.rmSync(actual_path, {recursive: true});
            
            // Removing from parent
            const parent = this.getFolder(parent_path)
            if (parent) {
                const index = parent.folders.findIndex((folder) => folder.folder_path === folder_path);
                if (index !== -1) parent.folders.splice(index, 1);
            }
            // Removing self
            this._folder_list.splice(index, 1); 
            // Removing childs
            for (let i = this._folder_list.length-1; i >= 0; i--) { 
                if (!this._folder_list[i].parent.startsWith(folder_path)) continue;
                this._folder_list.splice(i, 1);
            }
            return true;
        } catch (err) {
            console.log(`An error occured when deleting a folder!\n Deleting : ${folder_path} | ${actual_path}.\n Error: ${err}`);
            return false;
        }
    }

    /**
     * Turns a shortened file path into an actual file path.
     * (e.g. /$Download$/folder => /home/username/Download/folder)
     * @param file_path - The shortened file path
     * @returns The actual file path.
     */
    static getActualPath(file_path: string): string {
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
    static getFileType(file_name: string): FileTypes {
        if (file_name.endsWith(".json")) return FileTypes.JSON;
        for (const extension of IMAGE_FILE_EXTENSIONS) {
            if (file_name.endsWith(extension)) return FileTypes.Image;
        }
        return FileTypes.Others;
    }

    /**
     * Checks if file_type is one of the files in ALLOWED_FILE_TYPES.
     * @param file_type - FileType of a file
     * @returns If the file_type is allowed.
     */
    static isAllowedFileType(file_type: FileTypes): boolean {
        return (ALLOWED_FILE_TYPES.findIndex((type) => file_type === type) !== -1);
    }

    /**
     * Traverse through a folder and returns an array of FolderObject of the folder.
     * @param parent - parent folder of the folder_path
     * @param folder_path - the path of the folder to be traversed
     * @param recursive - If the folder should be traversed recursively
     * @returns An array of FolderObject.
     */
    static _traverseFolder(parent: string, folder_path: string, recursive: boolean): Array<FolderObject> {
        const actual_folder_path = this.getActualPath(folder_path);
        const obj_list = fs.readdirSync(actual_folder_path);
        const folder: FolderObject = {
            parent: parent,
            folder_name: folder_path.split("/").at(-1) ?? "Error",
            folder_path: folder_path,
            folders: [],
            files: [],
        };
        const folders = [folder];

        for (const obj of obj_list) {
            const obj_path = `${folder_path}/${obj}`;
            const actual_obj_path = `${actual_folder_path}/${obj}`;

            const is_dir = fs.lstatSync(actual_obj_path).isDirectory();
            if (is_dir) {
                if (recursive) {
                    const inner_folders = this._traverseFolder(folder_path, obj_path, true);
                    folders.push(...inner_folders);
                    folder.folders.push(inner_folders[0]);
                } else {
                    const folder_obj: FolderObject = {
                        parent: folder_path,
                        folder_name: obj,
                        folder_path: obj_path,
                        folders: [],
                        files: []
                    }
                    folders.push(folder_obj);
                    folder.folders.push(folder_obj);
                }
            } else {
                const file_type = this.
                getFileType(obj);
                if (file_type === FileTypes.Image || file_type === FileTypes.JSON) {
                    folder.files.push({
                        file_name: obj,
                        file_type: this.
                getFileType(obj),
                    });   
                }
            }
        }
        return folders;
    }

    static _throwError(error_text: string) {
        throw new Error(`${error_text} (In FolderManager)`);
    }
}