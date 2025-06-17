import { Router } from "express";
import { FolderManager } from "../../code/folders/folder_manager.js";

const deleteFiles = Router();

deleteFiles.post("/deleteFiles", async (req, res) => {
    try {        
        // 1. Check if all files & folders exists.
        const files: Array<string> = JSON.parse(req.body.files ?? "[]");
        const folders: Array<string> = JSON.parse(req.body.folders ?? "[]");
        if (files.length === 0 && folders.length === 0) {
            res.status(400).send({
                message: "Invalid Request!"
            });
            return;
        }
        for (const file_path of files) {
            if (!FolderManager.fileExist(file_path)) {
                res.status(400).send({
                    message: "Some files does not exist!"
                });
                return;
            }
        }
        for (const folder_path of folders) {
            if (!FolderManager.folderExist(folder_path)) {
                res.status(400).send({
                    message: "Some folders does not exist!"
                });
                return;
            }
        }
        
        // 2. Delete File & Update Folders
        for (const file_path of files) {
            FolderManager.deleteFile(file_path);
        }
        for (const folder_path of folders) {
            FolderManager.deleteFolder(folder_path);
        }

        // 3. Respond
        res.status(200).send();
    } catch {
        res.status(400).send({
            message: "Invalid Request!"
        });
        return;
    }
});

export default deleteFiles;