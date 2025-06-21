import { Router } from "express";
import { FolderManager } from "../../code/folders/folder_manager.js";

const renameFiles = Router();

renameFiles.post("/renameFiles", async (req, res) => {
    try {        
        const files: Array<string> = JSON.parse(req.body.files);
        const new_names: Array<string> = JSON.parse(req.body.newNames);
        
        if (files.length !== new_names.length) {
            res.status(400).send({
                message: "Invalid Request!"
            });
        }

        if (!FolderManager.renameFiles(files, new_names)) {
            res.status(400).send({
                message: "Invalid Request!"
            });
            return;
        }

        res.status(200).send();
    } catch {
        res.status(400).send({
            message: "Invalid Request!"
        });
        return;
    }
});

export default renameFiles;