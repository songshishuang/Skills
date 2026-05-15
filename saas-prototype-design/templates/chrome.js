// 某 SaaS 平台 v1 · Chrome 交互（侧栏激活态 / Toast / Modal / Drawer）

// ---------- 自动高亮侧栏 active item ----------
(function highlightActive() {
  const path = location.pathname.split('/').pop() || 'index.html';
  document.querySelectorAll('.sidebar-item[data-href]').forEach(el => {
    if (el.getAttribute('data-href') === path) {
      el.classList.add('active');
    }
  });
})();

// ---------- Toast ----------
window.toast = function(msg, type = 'info', timeout = 2500) {
  let stack = document.querySelector('.toast-stack');
  if (!stack) {
    stack = document.createElement('div');
    stack.className = 'toast-stack';
    document.body.appendChild(stack);
  }
  const t = document.createElement('div');
  t.className = 'toast ' + type;
  t.textContent = msg;
  stack.appendChild(t);
  setTimeout(() => { t.style.opacity = '0'; t.style.transition = 'opacity .2s'; }, timeout - 200);
  setTimeout(() => t.remove(), timeout);
};

// ---------- Modal ----------
window.showModal = function(id) {
  const el = document.getElementById(id);
  if (el) el.classList.add('show');
};
window.hideModal = function(id) {
  const el = document.getElementById(id);
  if (el) el.classList.remove('show');
};

// ---------- Drawer ----------
window.showDrawer = function(id) {
  const mask = document.querySelector('[data-drawer-mask="' + id + '"]');
  const drawer = document.getElementById(id);
  if (mask) mask.classList.add('show');
  if (drawer) drawer.classList.add('show');
};
window.hideDrawer = function(id) {
  const mask = document.querySelector('[data-drawer-mask="' + id + '"]');
  const drawer = document.getElementById(id);
  if (mask) mask.classList.remove('show');
  if (drawer) drawer.classList.remove('show');
};

// ---------- 全局点击委托：[data-action] ----------
document.addEventListener('click', (e) => {
  const trigger = e.target.closest('[data-action]');
  if (!trigger) return;
  const action = trigger.getAttribute('data-action');
  const arg = trigger.getAttribute('data-arg') || '';

  switch (action) {
    case 'toast':
      toast(arg || 'Action triggered', trigger.getAttribute('data-toast-type') || 'info');
      break;
    case 'modal-open':
      showModal(arg);
      break;
    case 'modal-close':
      hideModal(arg);
      break;
    case 'drawer-open':
      showDrawer(arg);
      break;
    case 'drawer-close':
      hideDrawer(arg);
      break;
    case 'confirm':
      if (confirm(trigger.getAttribute('data-confirm-msg') || '确认执行？')) {
        toast(trigger.getAttribute('data-confirm-toast') || '已执行', 'success');
        const cb = trigger.getAttribute('data-confirm-callback');
        if (cb && window[cb]) window[cb]();
      }
      break;
    case 'tab-switch': {
      const group = trigger.closest('[data-tab-group]');
      if (!group) break;
      group.querySelectorAll('.tab').forEach(t => t.classList.remove('active'));
      trigger.classList.add('active');
      const target = trigger.getAttribute('data-tab-target');
      group.parentElement.querySelectorAll('[data-tab-content]').forEach(c => {
        c.style.display = c.getAttribute('data-tab-content') === target ? '' : 'none';
      });
      break;
    }
  }
});

// ---------- ESC 关闭模态 / 抽屉 ----------
document.addEventListener('keydown', (e) => {
  if (e.key === 'Escape') {
    document.querySelectorAll('.modal-mask.show').forEach(m => m.classList.remove('show'));
    document.querySelectorAll('.drawer.show').forEach(d => d.classList.remove('show'));
    document.querySelectorAll('.drawer-mask.show').forEach(m => m.classList.remove('show'));
  }
});

// ---------- ⌘K 唤起搜索（占位） ----------
document.addEventListener('keydown', (e) => {
  if ((e.metaKey || e.ctrlKey) && e.key === 'k') {
    e.preventDefault();
    const input = document.querySelector('.topbar-search-input');
    if (input) input.focus();
  }
});
