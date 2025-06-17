import { Router } from "express";
import { FolderManager } from "../../code/folders/folder_manager.js";

const renameFile = Router();

renameFile.post("/renameFile", async (req, res) => {
    try {        
        const file_path: string = req.body.file
        const new_name: string = req.body.newName;

        if (!FolderManager.renameFile(file_path, new_name)) {
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

export default renameFile;