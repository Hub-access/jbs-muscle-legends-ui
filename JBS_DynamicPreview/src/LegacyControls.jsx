/**
 * 旧版四个功能页。名称来源：catalog.js（由 Luau 工程的共用清单生成）。
 * 这个 React 文件负责浏览器交互演示，不连接 Roblox、不发送购买或赠送请求。
 * 新增真实游戏功能时请到原生工程 BusinessBindings.lua 接线。
 */
import { catalog, labels } from "./catalog.js";

// 将输入统一为非负整数；0 的含义沿用旧版 UI。
export function countValue(value) {
  const number = Number(value);
  return Number.isFinite(number) ? Math.max(0, Math.floor(number)) : 0;
}

export function LegacyControls({
  page,
  choices,
  setChoices,
  selected,
  toggle,
  parameters,
  setParameters,
  execute,
  notify,
  busy,
  action,
  Toggle,
}) {
  const changeChoice = (key, value) =>
    setChoices((old) => ({ ...old, [key]: value }));
  const featureRow = (id) => {
    const feature = catalog.features.find((item) => item.id === id);
    return (
      <div className="legacy-toggle-row" key={id}>
        <div>
          <strong>{feature.title}</strong>
          <small>{feature.description} · 演示开关</small>
        </div>
        <Toggle
          id={id}
          title={feature.title}
          on={!!selected[id]}
          onChange={toggle}
        />
      </div>
    );
  };
  return (
    <div className={"legacy-page legacy-" + page}>
      {page === "teleport" && (
        <>
          <div className="legacy-caption">
            <h2>传送地点</h2>
            <p>旧版 14 个地点 · 点击查看传送反馈</p>
          </div>
          <div className="teleport-grid">
            {catalog.teleports.map((item) => (
              <button
                key={item.id}
                className={choices.teleport === item.id ? "chosen" : ""}
                disabled={busy}
                onClick={() => {
                  changeChoice("teleport", item.id);
                  execute("teleport", item.id);
                }}
              >
                <img src="/assets/icons/pin.png" alt="" />
                <span>{item.label}</span>
                <b>›</b>
              </button>
            ))}
          </div>
        </>
      )}
      {page === "pets" && (
        <>
          <div className="legacy-caption">
            <h2>宠物商店购买</h2>
            <p>旧版内置的 49 项兜底名称 · 当前商店库存未验证</p>
          </div>
          <label className="legacy-field">
            {labels.petChoice}
            <select
              value={choices.pets || ""}
              onChange={(e) => changeChoice("pets", e.target.value)}
            >
              <option value="">请选择宠物/光环</option>
              {/* 使用与 Luau table.sort 相同的 Unicode 顺序，两个预览的选项顺序一致。 */}
              {[...catalog.fallbackPets].sort().map((name) => (
                <option key={name}>{name}</option>
              ))}
            </select>
          </label>
          <div className="legacy-actions">
            <button
              onClick={() =>
                notify("已刷新宠物列表，共 49 项 · 浏览器使用旧版内置列表")
              }
            >
              {labels.refreshPets}
            </button>
            <button
              className="primary"
              disabled={busy || !choices.pets}
              onClick={() => execute("pets", choices.pets)}
            >
              {labels.buyPet}
            </button>
          </div>
          {featureRow("petbuy")}
        </>
      )}
      {page === "boss" && (
        <>
          <div className="legacy-caption">
            <h2>Boss</h2>
            <p>由游戏中的原有逻辑自动寻找 Boss</p>
          </div>
          {featureRow("boss")}
          <p className="legacy-help">
            开启后点击下方「开始脚本」体验运行状态。浏览器只演示界面反馈。
          </p>
        </>
      )}
      {page === "rebirth" && (
        <>
          <div className="legacy-caption">
            <h2>换包重生</h2>
            <p>沿用旧版功能名称与字段</p>
          </div>
          <div className="legacy-two-columns">
            {featureRow("packrebirth")}
            {featureRow("fasttrain")}
          </div>
          <div className="egg-heading">
            <h3>蛋白蛋</h3>
            {featureRow("eategg")}
          </div>
          <div className="legacy-two-columns egg-fields">
            <label className="legacy-field">
              {labels.eggTarget}
              <select aria-label="送蛋目标" disabled value="">
                <option value="">未连接游戏，暂无在线玩家</option>
              </select>
            </label>
            <label className="legacy-field">
              {labels.giftAmount}
              <input
                type="number"
                min="0"
                step="1"
                placeholder="0为全部"
                value={parameters.giftAmount}
                onChange={(e) =>
                  setParameters((old) => ({
                    ...old,
                    giftAmount: countValue(e.target.value),
                  }))
                }
              />
            </label>
          </div>
          <div className="gift-note">
            <span>0 为全部 · 目标从游戏内同服玩家读取</span>
            <button
              className="primary"
              disabled
              title="连接真实玩家列表后才能送蛋"
            >
              {labels.giftEggs}
            </button>
          </div>
        </>
      )}
      <div
        className={"legacy-feedback " + (action ? "has-result" : "")}
        role="status"
      >
        {action || "名称已与旧版对齐 · 操作仅演示界面反馈"}
      </div>
    </div>
  );
}
