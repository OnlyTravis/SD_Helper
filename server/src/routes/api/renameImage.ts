import { Router } from "express";
import { FolderManager } from "../../code/folders/folder_manager.js";

const renameImage = Router();

renameImage.post("/renameImage", async (req, res) => {
    try {        
        const image_path: string = req.body.image
        const new_name: string = req.body.newName;

        if (!FolderManager.renameFile(image_path, new_name)) {
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

export default renameImage;