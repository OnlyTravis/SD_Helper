import { Router } from "express";
import { FolderManager } from "../code/folders/folder_manager.js";

const apiRouter = Router();

apiRouter.post("/getFolder", (req, res) => {
    if (!req.query || !req.query.folder || typeof req.query.folder !== "string") {
        res.status(400).send({
            message: "Invalid Request!"
        });
        return;
    }
    const folder = FolderManager.getFolder(req.query.folder);
    if (!folder) {
        res.status(400).send({
            message: "Folder not found!"
        });
        return;
    }
    res.status(200).json(folder);
});

export default apiRouter;