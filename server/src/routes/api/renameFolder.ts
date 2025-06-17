import { Router } from "express";
import { FolderManager } from "../../code/folders/folder_manager.js";

const renameFolder = Router();

renameFolder.post("/renameFolder", async (req, res) => {
    try {        
        const folder_path: string = req.body.folder
        const new_name: string = req.body.newName;

        if (!FolderManager.renameFolder(folder_path, new_name)) {
            res.status(400).send({
                message: "Invalid Request!"
            });
            return;
        }

        res.status(200).send();
    } catch (err) {
        console.log(err);
        res.status(400).send({
            message: "Invalid Request!"
        });
        return;
    }
});

export default renameFolder;