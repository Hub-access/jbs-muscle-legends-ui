/**
 * JBS 图五动态浏览器预览。
 * 阅读顺序：① catalog.js 名称清单 → ② 本文件状态/操作 → ③ LegacyControls.jsx 功能页 → ④ styles.css 外观。
 * React 的 useState 保存画面状态，useEffect 处理计时器和存储，useRef 保存不会引起重绘的运行标记。
 * 所有“运行”“购买”“传送”仅用于浏览器演示，不代表 Roblox 中真的执行了操作。
 */
import { catalog, labels } from "./catalog.js";
import { LegacyControls, countValue } from "./LegacyControls.jsx";
import { useEffect, useRef, useState } from "react";

const A = "/assets/";
// 人物样稿入口：保留已评审的主横幅，只逐步替换指定的人物位置。
// stage2 可回看原主横幅样稿；back-v1 只额外展示左下角新背影。
// URL 开关不写入配置或 localStorage；尺寸、动画、业务和授权保持原样。
const artPreview = new URLSearchParams(window.location.search).get("artPreview");
const backCharacterDraft = artPreview === "back-v1";
const stage2HeroDraft = artPreview === "stage2" || backCharacterDraft;
// 主横幅 v4 统一战队英文标语（每个单词首字母大写）；保留上一版中文标语和人物。
// 默认/功能页横幅同步修改烘焙文字，布局与业务逻辑保持原样。
const homeHeroAsset = stage2HeroDraft
  ? "/stage2/hero_clan_title_v4.png"
  : A + "hero_banner.png";
// 将背影资源单独映射，避免影响主横幅、启停区及功能页的其他图片。
const sidebarCharacterAsset = backCharacterDraft
  ? "/character-back/sidebar_back_v1.png"
  : A + "sidebar_art.png";
// 导航和开关的中文名称与原生 Luau 使用同一份资料。
const nav = catalog.pages;
const quick = catalog.features
  .slice(0, 3)
  .map((f) => [f.id, f.title, f.description, f.english, f.icon]);
const extras = catalog.features.slice(3).map((f) => [f.id, f.title, f.icon]);
const routes = [
  ["teleport", "传送地点", "旧版 14 个传送地点", "TELEPORT", "pin"],
  ["pets", "宠物商店购买", "选择宠物 / 光环", "PET SHOP", "pet"],
  ["boss", "自动打Boss", "自动寻找 Boss", "AUTO BOSS", "boss"],
];
const phaseNames = {
  idle: "未开始",
  starting: "启动中",
  running: "演示运行中",
  stopping: "停止中",
  stopped: "已停止",
  error: "错误",
};
function readSaved() {
  try {
    return JSON.parse(localStorage.getItem("jbs-05-browser-demo") || "{}");
  } catch {
    return {};
  }
}
function Icon({ name, className = "" }) {
  return (
    <img
      className={"icon " + className}
      src={`${A}icons/${name}.png`}
      alt=""
      draggable="false"
    />
  );
}
function Panel({
  as: Element = "section",
  className = "",
  children,
  ...props
}) {
  return (
    <Element className={"metal " + className} {...props}>
      {children}
    </Element>
  );
}
function Toggle({ id, title, on, onChange, compact = false }) {
  return (
    <button
      type="button"
      role="switch"
      aria-label={title}
      aria-checked={on}
      onClick={() => onChange(id)}
      className={`toggle ${on ? "on" : ""} ${compact ? "compact" : ""}`}
    >
      <span className="track">
        <span className="thumb" />
      </span>
      <span className="switch-label">{on ? "开启" : "关闭"}</span>
    </button>
  );
}
function Header({ title, english, icon }) {
  return (
    <div className="panel-heading">
      <Icon name={icon} />
      <h2>{title}</h2>
      {english && <span>{english}</span>}
    </div>
  );
}

export function App() {
  const saved = useRef(readSaved()).current;
  const [page, setPage] = useState(
    nav.some((n) => n[0] === saved.page) ? saved.page : "home",
  );
  // 只恢复现有的八个开关，清除上一版预览中的临时虚构项目。
  const [selected, setSelected] = useState(
    Object.fromEntries(
      catalog.features.map((f) => [f.id, saved.selected?.[f.id] === true]),
    ),
  );
  const [choices, setChoices] = useState({
    teleport: catalog.teleports.some((t) => t.id === saved.choices?.teleport)
      ? saved.choices.teleport
      : "",
    pets: catalog.fallbackPets.includes(saved.choices?.pets)
      ? saved.choices.pets
      : "",
  });
  const [parameters, setParameters] = useState({
    targetRebirths: countValue(saved.parameters?.targetRebirths),
    giftAmount: countValue(saved.parameters?.giftAmount),
  });
  const [reduced, setReduced] = useState(!!saved.reduced);
  const [phase, setPhase] = useState("idle");
  const phaseRef = useRef("idle");
  const [windowState, setWindow] = useState("open");
  const [comfort, setComfort] = useState(false);
  const [scale, setScale] = useState(1);
  // 第一阶段：窗口空间交给布局重排，默认保持 100% 逻辑字号。
  const [canvas, setCanvas] = useState({ width: 1672, height: 941 });
  const [offset, setOffset] = useState({ x: 0, y: 0 });
  const drag = useRef(null);
  const [message, setMessage] = useState(
    "动态预览已就绪。选择开关，再点击开始脚本。",
  );
  const [meters, setMeters] = useState({ train: 0, rebirth: 0, spin: 0 });
  const [seconds, setSeconds] = useState(0);
  const [action, setAction] = useState("");
  const [busyAction, setBusyAction] = useState(false);

  const generation = useRef(0),
    transition = useRef(null),
    actionTimer = useRef(null),
    runningTasks = useRef({});
  const [log, setLog] = useState([]);
  const notify = (text) => {
    setMessage(text);
    setLog((old) =>
      [
        {
          text,
          time: new Date().toLocaleTimeString("zh-CN", { hour12: false }),
        },
        ...old,
      ].slice(0, 12),
    );
  };
  const enterPhase = (p) => {
    phaseRef.current = p;
    setPhase(p);
  };
  // 浏览器仅保存界面选择，不保存“正在运行”，刷新后需要重新开始。
  useEffect(() => {
    localStorage.setItem(
      "jbs-05-browser-demo",
      JSON.stringify({ page, selected, choices, parameters, reduced }),
    );
  }, [page, selected, choices, parameters, reduced]);
  useEffect(() => {
    const resize = () => {
      const ratio = comfort ? 0.9 : 1;
      setScale(ratio);
      setCanvas({
        width: Math.min(1672, (window.innerWidth - 24) / ratio),
        height: Math.min(941, (window.innerHeight - 64) / ratio),
      });
      setOffset({ x: 0, y: 0 });
    };
    resize();
    window.addEventListener("resize", resize);
    return () => window.removeEventListener("resize", resize);
  }, [comfort]);
  useEffect(
    () => () => {
      clearTimeout(transition.current);
      clearTimeout(actionTimer.current);
    },
    [],
  );
  // 演示计数每秒更新一次；离开运行阶段自动移除计时器。
  useEffect(() => {
    if (phase !== "running") return;
    const timer = setInterval(() => {
      setSeconds((s) => s + 1);
      setMeters((m) => ({
        train: m.train + (runningTasks.current.train ? 1 : 0),
        rebirth: m.rebirth + (runningTasks.current.rebirth ? 1 : 0),
        spin: m.spin + (runningTasks.current.spin ? 1 : 0),
      }));
    }, 1000);
    return () => clearInterval(timer);
  }, [phase]);
  const toggle = (id) => {
    const on = !selected[id];
    setSelected({ ...selected, [id]: on });
    const title = [...quick, ...extras].find((f) => f[0] === id)?.[1] || id;
    notify(
      `${title}已${on ? "开启" : "关闭"}${phaseRef.current === "running" ? "；下一次开始时生效。" : " · 仅浏览器演示"}`,
    );
  };
  const navigate = (id) => {
    setPage(id);
    setAction("");
  };
  const start = () => {
    if (["starting", "running", "stopping"].includes(phaseRef.current)) {
      notify("演示任务已经启动，不会重复创建。");
      return;
    }
    if (selected.petbuy && !choices.pets) {
      notify("自动购买前请到宠物页选择宠物/光环。");
      return;
    }
    const active = Object.keys(selected).filter((k) => selected[k]);
    if (!active.length) {
      notify("请先开启至少一个演示功能。");
      return;
    }
    const token = ++generation.current;
    clearTimeout(transition.current);
    runningTasks.current = { ...selected };
    enterPhase("starting");
    notify("正在启动所选演示任务…");
    transition.current = setTimeout(
      () => {
        if (token !== generation.current) return;
        enterPhase("running");
        notify(`演示已开始 · ${active.length} 项已选择 · 未连接 Roblox`);
      },
      reduced ? 0 : 260,
    );
  };
  // 代次标记使尚未完成的旧启动失效，连续点击开始不会叠加循环。
  const stop = () => {
    ++generation.current;
    clearTimeout(transition.current);
    clearTimeout(actionTimer.current);
    setBusyAction(false);
    setAction("");
    enterPhase("stopping");
    notify("正在停止演示任务…");
    const token = generation.current;
    transition.current = setTimeout(
      () => {
        if (token !== generation.current) return;
        enterPhase("stopped");
        runningTasks.current = {};
        notify("演示已停止，所有功能选择已保留。");
      },
      reduced ? 0 : 160,
    );
  };
  const hide = (state) => {
    setWindow(state);
    notify(
      `${state === "closed" ? "窗口已关闭" : "窗口已最小化"}；可点击「恢复 JBS」。${phaseRef.current === "running" ? "演示任务继续运行。" : ""}`,
    );
  };
  const restore = () => {
    setWindow("open");
    setOffset({ x: 0, y: 0 });
  };
  // 一次性操作单独使用计时器；停止按钮和组件卸载都会取消它。
  const execute = (actionPage, target) => {
    if (busyAction || !target) return;
    setBusyAction(true);
    setAction("正在演示…");
    actionTimer.current = setTimeout(
      () => {
        setBusyAction(false);
        const result =
          actionPage === "teleport"
            ? `模拟传送：${target}`
            : `模拟购买一次：${target}`;
        setAction(result + " · 未执行游戏操作");
        notify(result + " · 未执行游戏操作");
      },
      reduced ? 0 : 600,
    );
  };
  // 顶栏拖动只移动窗口；按钮区独立，不会触发拖拽。
  const pointerDown = (e) => {
    if (e.button !== 0) return;
    drag.current = { x: e.clientX, y: e.clientY, origin: offset };
    e.currentTarget.setPointerCapture(e.pointerId);
  };
  const pointerMove = (e) => {
    if (!drag.current) return;
    setOffset({
      x: Math.max(
        -300,
        Math.min(300, drag.current.origin.x + e.clientX - drag.current.x),
      ),
      y: Math.max(
        -10,
        Math.min(200, drag.current.origin.y + e.clientY - drag.current.y),
      ),
    });
  };
  return (
    <main
      className={`${reduced ? "reduced" : ""} ${windowState !== "open" ? "hidden-window" : ""}`}
    >
      <div className="demo-strip">
        <span className="live-dot" />
        <strong>浏览器动态预览</strong>
        <span>演示数据 · 未连接 Roblox</span>
        <span className="strip-right">
          {backCharacterDraft
            ? "背影人物样稿 · 待确认 · 原生未接入"
            : stage2HeroDraft
            ? "主横幅人物样稿 · 待确认 · 原生未接入"
            : "图五 / 原生 Luau 配套预览"}
        </span>
      </div>
      {windowState !== "open" && (
        <div className="restore-screen">
          <img src={A + "logo_jbs.png"} alt="JBS 力量传奇" />
          <h1>{windowState === "closed" ? "窗口已关闭" : "窗口已最小化"}</h1>
          <p>
            {phase === "running"
              ? "演示任务仍在运行"
              : "你的选择和页面状态已保留"}
          </p>
          <button className="restore primary" onClick={restore}>
            恢复 JBS
          </button>
        </div>
      )}
      <div
        className="stage-space"
        style={{
          width: canvas.width * scale,
          height: canvas.height * scale,
          display: windowState === "open" ? "block" : "none",
          transform: `translate(${offset.x}px,${offset.y}px)`,
        }}
      >
        <div
          className={`stage ${phase === "running" ? "is-running" : ""}`}
          style={{
            transform: `scale(${scale})`,
            width: canvas.width,
            height: canvas.height,
          }}
          data-density={canvas.width < 1500 ? "narrow" : "desktop"}
          data-height={canvas.height < 900 ? "short" : "tall"}
        >
          <Panel className="outer-shell" aria-hidden="true" />
          <Panel className="sidebar">
            <img
              src={A + "logo_jbs.png"}
              className="logo"
              alt="JBS 力量传奇 / Roblox Script Hub"
            />
            <nav aria-label="主导航">
              {nav.map(([id, label, icon]) => (
                <button
                  key={id}
                  className={`nav-item ${page === id ? "active" : ""}`}
                  onClick={() => navigate(id)}
                  aria-current={page === id ? "page" : undefined}
                >
                  <Icon name={icon} />
                  <span>{label}</span>
                </button>
              ))}
            </nav>
            <img
              src={sidebarCharacterAsset}
              className="sidebar-art"
              alt={backCharacterDraft ? "我的 Roblox 角色背影样稿，待确认" : "JBS 力量角色装饰"}
            />
            <div className="sidebar-sign">
              力量不止 · 传奇永在<small>J B S F O R E V E R</small>
            </div>
          </Panel>
          <Panel className="topbar">
            <div
              className="drag-region"
              onPointerDown={pointerDown}
              onPointerMove={pointerMove}
              onPointerUp={() => (drag.current = null)}
              onLostPointerCapture={() => (drag.current = null)}
            >
              <strong>
                JBS MUSCLE LEGENDS <b>›››</b>
              </strong>
              <span>TRAIN HARDER · BECOME STRONGER</span>
              <img src={A + "slogan.png"} alt="More Power More Possibilities" />
            </div>
            <div className="window-controls">
              <button aria-label="最小化" onClick={() => hide("minimized")}>
                —
              </button>
              <button
                aria-label="切换窗口尺寸"
                onClick={() => setComfort(!comfort)}
              >
                □
              </button>
              <button aria-label="关闭窗口" onClick={() => hide("closed")}>
                ×
              </button>
            </div>
          </Panel>
          <div className="center-viewport">
            {page === "home" ? (
              <>
                <Panel className="hero">
                  <img
                    src={homeHeroAsset}
                    alt={
                      stage2HeroDraft
                        ? "JBS 主横幅人物样稿，待确认"
                        : "JBS 力量传奇主视觉"
                    }
                  />
                  <div className="hero-sweep" />
                </Panel>
                <Panel className="quick">
                  <Header title="快捷功能" icon="strength" />
                  <div className="quick-grid">
                    {quick.map(([id, title, desc, en, icon]) => (
                      <Panel
                        key={id}
                        className={`card feature-card ${selected[id] ? "selected" : ""}`}
                      >
                        <Icon name={icon} />
                        <div className="card-copy">
                          <h3>{title}</h3>
                          <p>{desc}</p>
                        </div>
                        <Toggle
                          id={id}
                          title={title}
                          on={!!selected[id]}
                          onChange={toggle}
                        />
                      </Panel>
                    ))}
                    {routes.map(([id, title, desc, en, icon]) => (
                      <Panel
                        as="button"
                        key={id}
                        className="card route-card"
                        onClick={() => navigate(id)}
                      >
                        <Icon name={icon} />
                        <div className="card-copy">
                          <h3>{title}</h3>
                          <p>{desc}</p>
                        </div>
                        <Icon name="arrow" className="arrow" />
                      </Panel>
                    ))}
                  </div>
                  <label className="quick-target">
                    {labels.targetRebirths}{" "}
                    <input
                      type="number"
                      min="0"
                      step="1"
                      aria-label="目标次数"
                      placeholder="重生目标，0为无限"
                      value={parameters.targetRebirths}
                      onChange={(e) =>
                        setParameters((old) => ({
                          ...old,
                          targetRebirths: countValue(e.target.value),
                        }))
                      }
                    />
                    <small>0 为无限</small>
                  </label>
                </Panel>
              </>
            ) : (
              <Panel className="detail-page" key={page}>
                <div className="detail-hero">
                  <img src={A + "hero_banner.png"} alt="" />
                  <div />
                  <Icon name={nav.find((n) => n[0] === page)[2]} />
                  <h1>{nav.find((n) => n[0] === page)[1]}</h1>
                  <p>
                    JBS MUSCLE LEGENDS <b>· 交互演示</b>
                  </p>
                </div>
                {page === "settings" ? (
                  <div className="settings-page">
                    <h2>界面设置</h2>
                    <label className="setting-block">
                      动效模式
                      <select
                        aria-label="动效模式"
                        value={reduced ? "reduced" : "full"}
                        onChange={(e) => {
                          setReduced(e.target.value === "reduced");
                          notify("界面动效已更新");
                        }}
                      >
                        <option value="full">完整效果</option>
                        <option value="reduced">减少动态</option>
                      </select>
                    </label>
                    <p>减少动态保留相同的图片、颜色与布局。</p>
                    <h3>最近操作</h3>
                    <div className="event-list">
                      {log.length ? (
                        log.slice(0, 4).map((item, i) => (
                          <div key={i}>
                            <time>{item.time}</time>
                            <span>{item.text}</span>
                          </div>
                        ))
                      ) : (
                        <p>你的点击反馈会显示在这里。</p>
                      )}
                    </div>
                    <p className="demo-note">
                      浏览器会保存页面、开关和选择。此处演示不控制 Roblox。
                    </p>
                  </div>
                ) : (
                  <LegacyControls
                    page={page}
                    choices={choices}
                    setChoices={setChoices}
                    selected={selected}
                    toggle={toggle}
                    parameters={parameters}
                    setParameters={setParameters}
                    execute={execute}
                    notify={notify}
                    busy={busyAction}
                    action={action}
                    Toggle={Toggle}
                  />
                )}
              </Panel>
            )}
          </div>
          <Panel className="control">
            <Header title="脚本控制" icon="bolt" />
            <div className="control-buttons">
              <button
                className={`start-button primary ${phase === "running" ? "running" : ""}`}
                onClick={start}
                disabled={phase === "starting" || phase === "stopping"}
              >
                <Icon name="play" />
                <span>
                  {phase === "starting"
                    ? "启动中…"
                    : phase === "running"
                      ? "演示运行中"
                      : "开始脚本"}
                </span>
              </button>
              <button
                className="stop-button"
                onClick={stop}
                disabled={phase === "stopping"}
              >
                <Icon name="stop" />
                <span>{phase === "stopping" ? "停止中…" : "停止脚本"}</span>
              </button>
            </div>
            <img
              src={A + "control_art.png"}
              className="control-art"
              alt="No limits, just gains"
            />
            <div className="feedback" role="status">
              {message}
            </div>
          </Panel>
          <Panel className="status">
            <Header title="脚本状态" icon="status" />
            <div className="status-row">
              <Icon name="game" />
              <div>
                <strong>浏览器预览</strong>
                <p>未连接 Roblox 游戏</p>
              </div>
              <span className="badge neutral">演示</span>
            </div>
            <div className="status-row">
              <Icon name="settings" />
              <div>
                <strong>{phaseNames[phase]}</strong>
                <p>
                  {phase === "running"
                    ? `演示计时 ${seconds} 秒`
                    : "仅管理本页演示任务"}
                </p>
              </div>
              <span className={`badge ${phase === "running" ? "pink" : ""}`}>
                {phase === "running"
                  ? "运行"
                  : phase === "idle"
                    ? "待机"
                    : phase === "stopped"
                      ? "停止"
                      : "演示"}
              </span>
            </div>
            <div className="status-row">
              <Icon name="version" />
              <div>
                <strong>版本 v5.0 UI</strong>
                <p>本地动态预览版本</p>
              </div>
              <span className="badge">本地</span>
            </div>
          </Panel>
          <Panel className="settings">
            <Header title="脚本设置" icon="settings" />
            {extras.map(([id, title, icon]) => (
              <div className="settings-row" key={id}>
                <Icon name={icon} />
                <span>{title}</span>
                <Toggle
                  id={id}
                  title={title + "（演示）"}
                  on={!!selected[id]}
                  onChange={toggle}
                  compact
                />
              </div>
            ))}
            <span className="settings-demo">以上开关仅演示界面状态</span>
          </Panel>
          <Panel className="user">
            <div className="user-top">
              <Icon name="crown" />
              <strong>JBS 体验用户</strong>
              <span className="badge">演示</span>
            </div>
            <div className="user-quote">
              <Icon name="gem" />
              <p>
                强大的不是脚本，
                <br />
                而是永不放弃的你。<small>— JBS</small>
              </p>
            </div>
          </Panel>
          <footer>
            J B S · M U S C L E L E G E N D S · R O B L O X{" "}
            <span>
              {phase === "running"
                ? `演示次数　锻炼 ${meters.train} · 重生 ${meters.rebirth} · 轮盘 ${meters.spin}`
                : "STRONGER THAN YESTERDAY"}
            </span>
          </footer>
        </div>
      </div>
    </main>
  );
}
