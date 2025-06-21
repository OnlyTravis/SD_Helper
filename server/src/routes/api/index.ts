import { Router } from "express";
import getFolder from "./getFolder.js";
import getImage from "./getImage.js";
import deleteFiles from "./deleteFiles.js";
import renameFile from "./renameFile.js";
import renameFiles from "./renameFiles.js";
import renameFolder from "./renameFolder.js";

const apiRouter = Router();
apiRouter.use(getFolder);
apiRouter.use(getImage);
apiRouter.use(deleteFiles);
apiRouter.use(renameFile);
apiRouter.use(renameFiles);
apiRouter.use(renameFolder);

export default apiRouter;