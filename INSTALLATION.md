# 📦 Cách cài đặt Vault Sync Plugin cho Obsidian

## 🎯 **Tổng quan**
Vault Sync là plugin Obsidian giúp **tự động sync vault** với Git repository. Plugin sẽ:
- ✅ Tự động sync theo thời gian định (1-60 phút)
- ✅ Hiển thị status trên status bar
- ✅ Manual sync bằng hotkey
- ✅ Hỗ trợ Windows, macOS, Linux

## 🚀 **Cài đặt cho Windows**

### **Bước 1: Chuẩn bị**
1. **Cài Git for Windows**: https://git-scm.com/download/win
2. **Vault đã là Git repository**: 
   ```cmd
   cd C:\path\to\your\vault
   git init
   git remote add origin https://github.com/username/repo.git
   ```

### **Bước 2: Download Plugin**
**Phương pháp A: Download từ GitHub**
1. Vào: https://github.com/kabuto-png/longneobsidian-vault-sync/releases
2. Download file `vault-sync.zip` từ release mới nhất
3. Giải nén ra 3 files: `main.js`, `manifest.json`, `styles.css`

**Phương pháp B: Clone repository**
```cmd
cd C:\Users\%USERNAME%\Documents
git clone https://github.com/kabuto-png/longneobsidian-vault-sync.git
```

### **Bước 3: Cài đặt Plugin**
1. **Tạo thư mục plugin**:
   ```
   YourVault\
   └── .obsidian\
       └── plugins\
           └── vault-sync\     <-- Tạo thư mục này
   ```

2. **Copy 3 files vào thư mục**:
   ```
   YourVault\.obsidian\plugins\vault-sync\
   ├── main.js
   ├── manifest.json
   └── styles.css
   ```

3. **Copy sync script**:
   ```
   YourVault\
   ├── sync-vault.bat         <-- Copy từ windows/sync-vault.bat
   └── .obsidian\
   ```

### **Bước 4: Enable Plugin**
1. Mở **Obsidian**
2. **Settings** (Ctrl+,)
3. **Community plugins** 
4. **Turn OFF** "Safe mode" (nếu đang bật)
5. **Browse** → Tìm **"Vault Sync"**
6. **Enable** plugin

### **Bước 5: Cấu hình Plugin**
1. **Settings** → **Community plugins** → **Vault Sync**
2. **Cấu hình**:
   ```
   Sync Script: sync-vault.bat
   Auto-sync: ON
   Interval: 5 minutes (hoặc tùy chọn)
   Notifications: ON
   ```

## 🎮 **Cách sử dụng**

### **Auto-sync**
- Plugin sẽ tự động sync theo thời gian đã set
- Thấy status ở bottom bar: `🔄 Auto: 5m | 2m ago | 47`

### **Manual sync**
- **Hotkey**: Ctrl+P → "Sync Vault (Manual)"
- **Ribbon**: Click icon 🔄 trên toolbar
- **Status bar**: Click vào status để xem thông tin

### **Theo dõi Status**
```
🔄 Auto: 5m | 2m ago | 47
│   │    │    │      │
│   │    │    │      └─ Số lần sync thành công
│   │    │    └─ Lần sync cuối cách đây 2 phút
│   │    └─ Sync mỗi 5 phút
│   └─ Auto-sync đang ON
└─ Icon sync
```

## 🔧 **Troubleshooting**

### **Plugin không xuất hiện**
1. **Restart Obsidian** hoàn toàn
2. Check thư mục: `YourVault\.obsidian\plugins\vault-sync\`
3. Đảm bảo có đủ 3 files: `main.js`, `manifest.json`, `styles.css`

### **Sync bị lỗi**
1. **Test sync script** trước:
   ```cmd
   cd C:\path\to\your\vault
   sync-vault.bat "Test commit"
   ```
2. **Check Git setup**:
   ```cmd
   git status
   git remote -v
   ```

### **Auto-sync không hoạt động**
1. **Check settings**: Auto-sync phải ON
2. **Check permissions**: Script có quyền execute
3. **Check interval**: Đợi đủ thời gian đã set

## 🏗️ **Build từ source (Advanced)**

Nếu muốn build plugin từ source code:

```cmd
# Clone repository
git clone https://github.com/kabuto-png/longneobsidian-vault-sync.git
cd longneobsidian-vault-sync

# Install dependencies
npm install

# Build plugin
npm run build

# Files sẽ có trong thư mục gốc:
# - main.js
# - manifest.json
# - styles.css (nếu có)
```

## 🎯 **Lưu ý quan trọng**

1. **Vault phải là Git repository** trước khi cài plugin
2. **Đảm bảo có internet** để push/pull
3. **Backup vault** trước khi sử dụng
4. **Test manual sync** trước khi bật auto-sync
5. **Script permissions** phải đúng (executable)

## 📞 **Hỗ trợ**

- **GitHub Issues**: https://github.com/kabuto-png/longneobsidian-vault-sync/issues
- **Documentation**: README.md trong repository
- **Windows Scripts**: Xem thư mục `/windows/` trong repo

---

🎉 **Chúc bạn sử dụng plugin thành công!** Vault của bạn sẽ được sync tự động và không bao giờ bị mất dữ liệu nữa!