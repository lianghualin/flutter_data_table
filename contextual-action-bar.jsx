import { useState, useEffect, useRef } from "react";

const DOMAINS = [
  { id: 1, name: "测试域", zoneId: 5, property: "Root Domain", remark: "开发测试环境域" },
  { id: 2, name: "服务器域", zoneId: 2, property: "Non Root Domain", remark: "核心服务器系统域" },
  { id: 3, name: "生产域", zoneId: 4, property: "Non Root Domain", remark: "工业生产控制域" },
  { id: 4, name: "办公域", zoneId: 3, property: "Non Root Domain", remark: "员工办公网络域" },
  { id: 5, name: "管理域", zoneId: 1, property: "Non Root Domain", remark: "网络管理和监控系统域" },
];

const CheckIcon = () => (
  <svg width="12" height="12" viewBox="0 0 12 12" fill="none">
    <path d="M2.5 6L5 8.5L9.5 3.5" stroke="white" strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round"/>
  </svg>
);

const PlusIcon = () => (
  <svg width="14" height="14" viewBox="0 0 14 14" fill="none">
    <path d="M7 2.5V11.5M2.5 7H11.5" stroke="currentColor" strokeWidth="1.8" strokeLinecap="round"/>
  </svg>
);

const TrashIcon = ({size = 14}) => (
  <svg width={size} height={size} viewBox="0 0 16 16" fill="none">
    <path d="M3 4.5H13M6.5 7V11.5M9.5 7V11.5M4 4.5L4.5 13C4.5 13.5523 4.94772 14 5.5 14H10.5C11.0523 14 11.5 13.5523 11.5 13L12 4.5M6 4.5V3C6 2.44772 6.44772 2 7 2H9C9.55228 2 10 2.44772 10 3V4.5" stroke="currentColor" strokeWidth="1.3" strokeLinecap="round" strokeLinejoin="round"/>
  </svg>
);

const EditIcon = () => (
  <svg width="14" height="14" viewBox="0 0 16 16" fill="none">
    <path d="M11.5 2.5L13.5 4.5M2 14L2.5 11.5L11 3L13 5L4.5 13.5L2 14Z" stroke="currentColor" strokeWidth="1.3" strokeLinecap="round" strokeLinejoin="round"/>
  </svg>
);

const SearchIcon = () => (
  <svg width="14" height="14" viewBox="0 0 16 16" fill="none">
    <circle cx="7" cy="7" r="4.5" stroke="currentColor" strokeWidth="1.4"/>
    <path d="M10.5 10.5L14 14" stroke="currentColor" strokeWidth="1.4" strokeLinecap="round"/>
  </svg>
);

const XIcon = () => (
  <svg width="14" height="14" viewBox="0 0 14 14" fill="none">
    <path d="M3.5 3.5L10.5 10.5M10.5 3.5L3.5 10.5" stroke="currentColor" strokeWidth="1.5" strokeLinecap="round"/>
  </svg>
);

const WarnIcon = () => (
  <svg width="20" height="20" viewBox="0 0 20 20" fill="none">
    <path d="M10 6V10.5M10 13.5V14M3.5 17H16.5L10 3L3.5 17Z" stroke="currentColor" strokeWidth="1.4" strokeLinecap="round" strokeLinejoin="round"/>
  </svg>
);

const SortIcon = () => (
  <svg width="10" height="10" viewBox="0 0 10 14" fill="none">
    <path d="M5 1V13M5 1L1.5 4.5M5 1L8.5 4.5M5 13L1.5 9.5M5 13L8.5 9.5" stroke="currentColor" strokeWidth="1.2" strokeLinecap="round" strokeLinejoin="round"/>
  </svg>
);

// Confirmation Modal
function ConfirmModal({ count, onConfirm, onCancel }) {
  return (
    <div style={{
      position: "fixed", inset: 0, zIndex: 1000,
      display: "flex", alignItems: "center", justifyContent: "center",
      background: "rgba(0,0,0,0.35)", backdropFilter: "blur(4px)",
      animation: "fadeIn 0.15s ease"
    }}>
      <div style={{
        background: "#fff", borderRadius: 16, padding: "32px 28px 24px",
        width: 400, boxShadow: "0 20px 60px rgba(0,0,0,0.15)",
        animation: "scaleIn 0.2s ease",
        textAlign: "center"
      }}>
        <div style={{
          width: 48, height: 48, borderRadius: 12,
          background: "#fef2f2", display: "flex", alignItems: "center", justifyContent: "center",
          margin: "0 auto 16px", color: "#dc2626"
        }}>
          <WarnIcon />
        </div>
        <h3 style={{ fontSize: 17, fontWeight: 700, marginBottom: 8, color: "#1a1d26" }}>
          确认删除
        </h3>
        <p style={{ fontSize: 14, color: "#6b7280", marginBottom: 24, lineHeight: 1.6 }}>
          您确定要删除选中的 <strong style={{color:"#dc2626"}}>{count}</strong> 个域吗？<br/>
          <span style={{fontSize: 12, color: "#9ca3af"}}>此操作不可恢复 / This action cannot be undone</span>
        </p>
        <div style={{ display: "flex", gap: 10, justifyContent: "center" }}>
          <button onClick={onCancel} style={{
            flex: 1, padding: "10px 20px", borderRadius: 10, border: "1.5px solid #e5e7eb",
            background: "#fff", fontSize: 14, fontWeight: 600, cursor: "pointer",
            color: "#374151", fontFamily: "inherit"
          }}>
            取消
          </button>
          <button onClick={onConfirm} style={{
            flex: 1, padding: "10px 20px", borderRadius: 10, border: "none",
            background: "#dc2626", color: "#fff", fontSize: 14, fontWeight: 600,
            cursor: "pointer", fontFamily: "inherit"
          }}>
            🗑 确认删除
          </button>
        </div>
      </div>
    </div>
  );
}

// Toast notification
function Toast({ message, visible }) {
  return (
    <div style={{
      position: "fixed", bottom: 32, left: "50%", transform: "translateX(-50%)",
      background: "#065f46", color: "#fff", padding: "10px 24px",
      borderRadius: 10, fontSize: 13, fontWeight: 600, zIndex: 1001,
      opacity: visible ? 1 : 0, transition: "opacity 0.3s ease",
      pointerEvents: "none", boxShadow: "0 8px 24px rgba(0,0,0,0.2)"
    }}>
      ✓ {message}
    </div>
  );
}

export default function NetworkDomainPage() {
  const [domains, setDomains] = useState(DOMAINS);
  const [selected, setSelected] = useState(new Set());
  const [search, setSearch] = useState("");
  const [showConfirm, setShowConfirm] = useState(false);
  const [toast, setToast] = useState({ visible: false, message: "" });
  const [sortField, setSortField] = useState(null);
  const [sortDir, setSortDir] = useState("asc");
  const barRef = useRef(null);

  const filtered = domains
    .filter(d => d.name.includes(search) || d.remark.includes(search) || d.property.toLowerCase().includes(search.toLowerCase()))
    .sort((a, b) => {
      if (!sortField) return 0;
      const va = a[sortField], vb = b[sortField];
      const cmp = typeof va === "number" ? va - vb : String(va).localeCompare(String(vb));
      return sortDir === "asc" ? cmp : -cmp;
    });

  const allSelected = filtered.length > 0 && filtered.every(d => selected.has(d.id));
  const someSelected = selected.size > 0;

  const toggleAll = () => {
    if (allSelected) {
      setSelected(new Set());
    } else {
      setSelected(new Set(filtered.map(d => d.id)));
    }
  };

  const toggleOne = (id) => {
    const next = new Set(selected);
    next.has(id) ? next.delete(id) : next.add(id);
    setSelected(next);
  };

  const handleSort = (field) => {
    if (sortField === field) {
      setSortDir(d => d === "asc" ? "desc" : "asc");
    } else {
      setSortField(field);
      setSortDir("asc");
    }
  };

  const handleDelete = () => {
    setDomains(prev => prev.filter(d => !selected.has(d.id)));
    const count = selected.size;
    setSelected(new Set());
    setShowConfirm(false);
    showToast(`已删除 ${count} 个域`);
  };

  const handleDeleteOne = (id) => {
    setDomains(prev => prev.filter(d => d.id !== id));
    selected.delete(id);
    setSelected(new Set(selected));
    showToast("已删除 1 个域");
  };

  const showToast = (msg) => {
    setToast({ visible: true, message: msg });
    setTimeout(() => setToast({ visible: false, message: "" }), 2200);
  };

  const resetData = () => {
    setDomains(DOMAINS);
    setSelected(new Set());
    showToast("数据已重置");
  };

  return (
    <div style={{
      minHeight: "100vh",
      background: "linear-gradient(160deg, #f0f4ff 0%, #f7f8fc 40%, #fafbfe 100%)",
      fontFamily: "'SF Pro Display', -apple-system, 'PingFang SC', 'Noto Sans SC', sans-serif",
      padding: "24px 16px",
      color: "#1a1d26"
    }}>
      <style>{`
        @keyframes fadeIn { from { opacity: 0; } to { opacity: 1; } }
        @keyframes scaleIn { from { opacity: 0; transform: scale(0.95); } to { opacity: 1; transform: scale(1); } }
        @keyframes slideDown { from { opacity: 0; transform: translateY(-8px); } to { opacity: 1; transform: translateY(0); } }
        @keyframes barSlide { from { opacity: 0; transform: translateY(-100%); } to { opacity: 1; transform: translateY(0); } }
      `}</style>

      <div style={{ maxWidth: 960, margin: "0 auto" }}>
        {/* Page Header */}
        <div style={{ display: "flex", alignItems: "center", gap: 12, marginBottom: 24 }}>
          <div style={{
            width: 40, height: 40, borderRadius: 12,
            background: "linear-gradient(135deg, #3b82f6, #6366f1)",
            display: "flex", alignItems: "center", justifyContent: "center",
            color: "#fff", fontSize: 18, fontWeight: 700
          }}>🌐</div>
          <div>
            <h1 style={{ fontSize: 22, fontWeight: 700, margin: 0 }}>Network — Domain</h1>
            <p style={{ fontSize: 12, color: "#9ca3af", margin: 0 }}>安全域管理 · Contextual Action Bar Demo</p>
          </div>
          <button onClick={resetData} style={{
            marginLeft: "auto", padding: "6px 14px", borderRadius: 8,
            border: "1.5px solid #e5e7eb", background: "#fff", fontSize: 12,
            fontWeight: 600, cursor: "pointer", color: "#6b7280", fontFamily: "inherit"
          }}>↻ Reset Data</button>
        </div>

        {/* Tabs */}
        <div style={{
          display: "flex", borderRadius: 12, overflow: "hidden",
          border: "1.5px solid #e5e7eb", marginBottom: 20, background: "#fff"
        }}>
          <div style={{
            flex: 1, padding: "12px 0", textAlign: "center",
            background: "linear-gradient(135deg, #3b82f6, #4f7cf6)", color: "#fff",
            fontWeight: 700, fontSize: 14, cursor: "pointer"
          }}>
            📋 Domain
          </div>
          <div style={{
            flex: 1, padding: "12px 0", textAlign: "center",
            color: "#6b7280", fontWeight: 600, fontSize: 14, cursor: "pointer"
          }}>
            🔗 Network
          </div>
        </div>

        {/* Main Card */}
        <div style={{
          background: "#fff", borderRadius: 16,
          boxShadow: "0 1px 3px rgba(0,0,0,0.04), 0 4px 12px rgba(0,0,0,0.03)",
          border: "1px solid #e8eaef", overflow: "hidden"
        }}>
          {/* ===== TOOLBAR / CONTEXTUAL BAR ===== */}
          {someSelected ? (
            /* === STATE 2: Selection bar === */
            <div ref={barRef} style={{
              padding: "12px 20px",
              display: "flex", alignItems: "center", gap: 12,
              background: "linear-gradient(135deg, #eff6ff, #eef2ff)",
              borderBottom: "1.5px solid #bfdbfe",
              animation: "barSlide 0.2s ease",
            }}>
              {/* Selection count */}
              <div style={{
                display: "flex", alignItems: "center", gap: 8,
                fontSize: 13, fontWeight: 700, color: "#2563eb"
              }}>
                <div style={{
                  width: 22, height: 22, borderRadius: 6,
                  background: "#3b82f6", display: "flex",
                  alignItems: "center", justifyContent: "center"
                }}>
                  <CheckIcon />
                </div>
                已选中 {selected.size} 项
              </div>

              {/* Select all shortcut */}
              <button onClick={toggleAll} style={{
                padding: "5px 12px", borderRadius: 7,
                border: "1px solid #93c5fd", background: "#dbeafe",
                fontSize: 12, fontWeight: 600, cursor: "pointer",
                color: "#1d4ed8", fontFamily: "inherit"
              }}>
                {allSelected ? "取消全选" : `全选 (${filtered.length})`}
              </button>

              {/* Spacer */}
              <div style={{ flex: 1 }} />

              {/* Delete */}
              <button onClick={() => setShowConfirm(true)} style={{
                padding: "7px 18px", borderRadius: 8,
                border: "none", background: "#dc2626", color: "#fff",
                fontSize: 13, fontWeight: 700, cursor: "pointer",
                display: "flex", alignItems: "center", gap: 6,
                fontFamily: "inherit", boxShadow: "0 2px 8px rgba(220,38,38,0.3)"
              }}>
                <TrashIcon size={13} /> 删除选中 ({selected.size})
              </button>
            </div>
          ) : (
            /* === STATE 1: Normal toolbar === */
            <div style={{
              padding: "14px 20px",
              display: "flex", alignItems: "center", gap: 12,
              borderBottom: "1px solid #f1f2f5",
              animation: "slideDown 0.2s ease"
            }}>
              <button style={{
                padding: "8px 18px", borderRadius: 9,
                border: "none", background: "linear-gradient(135deg, #3b82f6, #4f7cf6)",
                color: "#fff", fontSize: 13, fontWeight: 700,
                cursor: "pointer", display: "flex", alignItems: "center", gap: 6,
                fontFamily: "inherit", boxShadow: "0 2px 8px rgba(59,130,246,0.3)"
              }}>
                <PlusIcon /> Add Domain
              </button>

              <div style={{ flex: 1 }} />

              {/* Search */}
              <div style={{
                display: "flex", alignItems: "center", gap: 8,
                padding: "7px 14px", borderRadius: 9,
                border: "1.5px solid #e5e7eb", background: "#fafbfc",
                minWidth: 200
              }}>
                <SearchIcon />
                <input
                  value={search}
                  onChange={e => setSearch(e.target.value)}
                  placeholder="Search domains..."
                  style={{
                    border: "none", background: "transparent", outline: "none",
                    fontSize: 13, color: "#1a1d26", width: "100%",
                    fontFamily: "inherit"
                  }}
                />
                {search && (
                  <span onClick={() => setSearch("")} style={{ cursor: "pointer", color: "#9ca3af", fontSize: 16 }}>×</span>
                )}
              </div>
            </div>
          )}

          {/* ===== TABLE ===== */}
          <div>
            {/* Header */}
            <div style={{
              display: "grid",
              gridTemplateColumns: "44px 1.4fr 0.6fr 1fr 1.4fr 100px",
              padding: "10px 20px",
              borderBottom: "1px solid #f1f2f5",
              background: "#fafbfc",
              fontSize: 11, fontWeight: 700,
              color: "#9ca3af",
              textTransform: "uppercase",
              letterSpacing: "0.5px",
              alignItems: "center"
            }}>
              <div style={{ display: "flex", justifyContent: "center" }}>
                <div
                  onClick={toggleAll}
                  style={{
                    width: 18, height: 18, borderRadius: 5, cursor: "pointer",
                    border: allSelected ? "none" : "1.5px solid #d1d5db",
                    background: allSelected ? "#3b82f6" : "#fff",
                    display: "flex", alignItems: "center", justifyContent: "center",
                    transition: "all 0.15s"
                  }}
                >
                  {allSelected && <CheckIcon />}
                </div>
              </div>
              <div onClick={() => handleSort("name")} style={{ cursor: "pointer", display: "flex", alignItems: "center", gap: 4 }}>
                Domain Name {sortField === "name" && (sortDir === "asc" ? "↑" : "↓")}
              </div>
              <div onClick={() => handleSort("zoneId")} style={{ cursor: "pointer", display: "flex", alignItems: "center", gap: 4 }}>
                域号 {sortField === "zoneId" && (sortDir === "asc" ? "↑" : "↓")}
              </div>
              <div>Property</div>
              <div>Remark</div>
              <div style={{ textAlign: "center" }}>操作</div>
            </div>

            {/* Rows */}
            {filtered.length === 0 ? (
              <div style={{ padding: "48px 20px", textAlign: "center", color: "#9ca3af", fontSize: 14 }}>
                No domains found
              </div>
            ) : (
              filtered.map((domain, i) => {
                const isSelected = selected.has(domain.id);
                return (
                  <div
                    key={domain.id}
                    style={{
                      display: "grid",
                      gridTemplateColumns: "44px 1.4fr 0.6fr 1fr 1.4fr 100px",
                      padding: "14px 20px",
                      borderBottom: "1px solid #f3f4f6",
                      alignItems: "center",
                      fontSize: 13,
                      background: isSelected ? "#eff6ff" : i % 2 === 1 ? "#fafbfc" : "#fff",
                      transition: "background 0.15s",
                      animation: `slideDown 0.15s ease ${i * 0.03}s both`
                    }}
                  >
                    {/* Checkbox */}
                    <div style={{ display: "flex", justifyContent: "center" }}>
                      <div
                        onClick={() => toggleOne(domain.id)}
                        style={{
                          width: 18, height: 18, borderRadius: 5, cursor: "pointer",
                          border: isSelected ? "none" : "1.5px solid #d1d5db",
                          background: isSelected ? "#3b82f6" : "#fff",
                          display: "flex", alignItems: "center", justifyContent: "center",
                          transition: "all 0.15s"
                        }}
                      >
                        {isSelected && <CheckIcon />}
                      </div>
                    </div>

                    {/* Domain Name */}
                    <div style={{ fontWeight: 600, color: "#1a1d26" }}>{domain.name}</div>

                    {/* Zone ID */}
                    <div style={{ color: "#6b7280" }}>{domain.zoneId}</div>

                    {/* Property Badge */}
                    <div>
                      <span style={{
                        fontSize: 11, fontWeight: 600, padding: "3px 10px",
                        borderRadius: 6,
                        background: domain.property === "Root Domain" ? "#eff6ff" : "#f3f4f6",
                        color: domain.property === "Root Domain" ? "#2563eb" : "#6b7280"
                      }}>
                        {domain.property === "Root Domain" ? "Root" : "Non Root"}
                      </span>
                    </div>

                    {/* Remark */}
                    <div style={{ color: "#6b7280", fontSize: 12 }}>{domain.remark}</div>

                    {/* Row Actions */}
                    <div style={{ display: "flex", gap: 6, justifyContent: "center" }}>
                      <button style={{
                        width: 32, height: 32, borderRadius: 8, border: "1.5px solid #e5e7eb",
                        background: "#fff", cursor: "pointer", display: "flex",
                        alignItems: "center", justifyContent: "center", color: "#6b7280",
                        transition: "all 0.15s"
                      }} title="修改">
                        <EditIcon />
                      </button>
                      <button onClick={() => handleDeleteOne(domain.id)} style={{
                        width: 32, height: 32, borderRadius: 8, border: "1.5px solid #fecaca",
                        background: "#fff", cursor: "pointer", display: "flex",
                        alignItems: "center", justifyContent: "center", color: "#ef4444",
                        transition: "all 0.15s"
                      }} title="删除">
                        <TrashIcon />
                      </button>
                    </div>
                  </div>
                );
              })
            )}
          </div>

          {/* Footer */}
          <div style={{
            padding: "12px 20px",
            display: "flex", alignItems: "center", justifyContent: "space-between",
            borderTop: "1px solid #f1f2f5", background: "#fafbfc",
            fontSize: 12, color: "#9ca3af"
          }}>
            <span>显示 1-{filtered.length} 条，共 {domains.length} 条</span>
            <div style={{ display: "flex", gap: 4, alignItems: "center" }}>
              <span style={{ marginRight: 8 }}>10 条/页</span>
              <button style={{
                width: 28, height: 28, borderRadius: 6, border: "1px solid #e5e7eb",
                background: "#fff", cursor: "pointer", fontSize: 12, color: "#9ca3af"
              }}>‹</button>
              <button style={{
                width: 28, height: 28, borderRadius: 6, border: "none",
                background: "#3b82f6", color: "#fff", fontSize: 12, fontWeight: 700
              }}>1</button>
              <button style={{
                width: 28, height: 28, borderRadius: 6, border: "1px solid #e5e7eb",
                background: "#fff", cursor: "pointer", fontSize: 12, color: "#9ca3af"
              }}>›</button>
            </div>
          </div>
        </div>

        {/* ===== Annotation Panel ===== */}
        <div style={{
          marginTop: 24, background: "#fff", borderRadius: 14,
          border: "1px solid #e8eaef", padding: 24,
          boxShadow: "0 1px 3px rgba(0,0,0,0.03)"
        }}>
          <h3 style={{ fontSize: 15, fontWeight: 700, marginBottom: 16, color: "#1a1d26" }}>
            📐 Design Details / 设计细节
          </h3>
          <div style={{ display: "grid", gridTemplateColumns: "1fr 1fr", gap: 12 }}>
            {[
              { icon: "🔄", title: "Toolbar ↔ Context Bar 切换", desc: "勾选任意 checkbox 后，普通工具栏滑出，蓝色上下文操作栏滑入，取消选择后恢复。" },
              { icon: "🛡", title: "二次确认弹窗", desc: "点击「删除选中」后弹出确认弹窗，显示将要删除的数量，防止误操作。" },
              { icon: "🎯", title: "视觉层级分离", desc: "Add 按钮蓝色渐变突出主操作；Delete 仅在选中态出现，红色高对比引起注意。" },
              { icon: "✨", title: "行内操作轻量化", desc: "每行的修改/删除改为 icon-only 按钮，降低视觉噪音，hover 时高亮。" },
              { icon: "🔍", title: "搜索集成", desc: "工具栏右侧集成搜索框，支持按域名、备注模糊搜索，大数据量时也能快速定位。" },
              { icon: "📊", title: "全选/取消全选", desc: "上下文栏内提供「全选」快捷按钮，批量操作效率更高。" },
            ].map((item, i) => (
              <div key={i} style={{
                padding: "12px 14px", borderRadius: 10,
                background: "#f8f9fc", border: "1px solid #f0f1f5",
                fontSize: 12, lineHeight: 1.6
              }}>
                <div style={{ fontWeight: 700, marginBottom: 4, fontSize: 13 }}>
                  {item.icon} {item.title}
                </div>
                <div style={{ color: "#6b7280" }}>{item.desc}</div>
              </div>
            ))}
          </div>
        </div>
      </div>

      {/* Confirm Modal */}
      {showConfirm && (
        <ConfirmModal
          count={selected.size}
          onConfirm={handleDelete}
          onCancel={() => setShowConfirm(false)}
        />
      )}

      {/* Toast */}
      <Toast message={toast.message} visible={toast.visible} />
    </div>
  );
}
