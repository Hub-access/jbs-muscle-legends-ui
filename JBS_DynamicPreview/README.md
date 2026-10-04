# JBS 当前浏览器演示

这是原生工程的静态人物交互演示；不会读取 Roblox 玩家，也不会执行传送、购买或训练。正背面自动角色在相邻 `JBS_Reference05` 中实现，原生尚待实际验收。

```sh
npm ci
npm run dev -- --host 127.0.0.1 --port 8775
```

打开 `http://127.0.0.1:8775/?artPreview=back-v1` 查看当前主横幅和背影素材组合。界面、开关、输入和启停逻辑保持原样；未收录历史评审网页、旧样稿或账号页面截图。

构建检查：`npm run build`；路由与打包检查：`npm run test:sites`。没有自动部署网站。

阅读 `src/App.jsx`、`src/LegacyControls.jsx` 和 `src/styles.css` 中的中文注释。修改共用名称后运行相邻原生工程的 `tools/sync_catalog.py`。
