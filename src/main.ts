import { Plugin, Notice, PluginSettingTab, Setting, App } from 'obsidian';
import { exec } from 'child_process';
import { promisify } from 'util';

const execAsync = promisify(exec);

export interface VaultSyncSettings {
    syncScript: string;
    autoSyncInterval: number;
    autoSyncEnabled: boolean;
    showNotifications: boolean;
    syncOnStartup: boolean;
    lastSyncTime: string | null;
    syncCount: number;
}

const DEFAULT_SETTINGS: VaultSyncSettings = {
    syncScript: 'sync-vault-advanced.sh',
    autoSyncInterval: 5,
    autoSyncEnabled: false,
    showNotifications: true,
    syncOnStartup: false,
    lastSyncTime: null,
    syncCount: 0
};

export default class VaultSyncPlugin extends Plugin {
    settings: VaultSyncSettings;
    private statusBarItemEl: HTMLElement;
    private autoSyncInterval: NodeJS.Timer | null = null;
    private lastSyncTime: string | null = null;
    private syncCount = 0;

    async onload() {
        console.log('Loading Vault Sync Plugin...');
        
        try {
            await this.loadSettings();
            
            // Add ribbon icon
            this.addRibbonIcon('sync', 'Vault Sync', () => this.syncVault());

            // Add commands
            this.addCommand({
                id: 'sync-vault-manual',
                name: 'Sync Vault (Manual)',
                callback: () => this.syncVault()
            });

            this.addCommand({
                id: 'toggle-auto-sync', 
                name: 'Toggle Auto-Sync',
                callback: () => this.toggleAutoSync()
            });

            this.addCommand({
                id: 'view-sync-status',
                name: 'View Sync Status',
                callback: () => this.showSyncStatus()
            });

            // Add settings tab
            this.addSettingTab(new VaultSyncSettingTab(this.app, this));

            // Add status bar
            this.statusBarItemEl = this.addStatusBarItem();
            this.updateStatusBar();

            // Setup auto-sync if enabled
            this.setupAutoSync();

            console.log('Vault Sync Plugin loaded successfully');
            
        } catch (error) {
            console.error('Error loading Vault Sync Plugin:', error);
        }
    }

    onunload() {
        console.log('Unloading Vault Sync Plugin...');
        try {
            this.clearAutoSync();
            console.log('Vault Sync Plugin unloaded successfully');
        } catch (error) {
            console.error('Error unloading Vault Sync Plugin:', error);
        }
    }

    async loadSettings() {
        this.settings = Object.assign({}, DEFAULT_SETTINGS, await this.loadData());
        this.lastSyncTime = this.settings.lastSyncTime;
        this.syncCount = this.settings.syncCount || 0;
    }

    async saveSettings() {
        this.settings.lastSyncTime = this.lastSyncTime;
        this.settings.syncCount = this.syncCount;
        await this.saveData(this.settings);
    }

    private updateStatusBar() {
        if (!this.statusBarItemEl) return;
        
        const now = new Date();
        let statusText = '';
        
        if (this.settings.autoSyncEnabled) {
            statusText += `🔄 Auto: ${this.settings.autoSyncInterval}m`;
        } else {
            statusText += '⏸️ Manual';
        }
        
        if (this.lastSyncTime) {
            const lastSync = new Date(this.lastSyncTime);
            const diffMinutes = Math.floor((now.getTime() - lastSync.getTime()) / (1000 * 60));
            
            if (diffMinutes < 1) {
                statusText += ' | Just now';
            } else if (diffMinutes < 60) {
                statusText += ` | ${diffMinutes}m ago`;
            } else {
                const diffHours = Math.floor(diffMinutes / 60);
                statusText += ` | ${diffHours}h ago`;
            }
        } else {
            statusText += ' | Never';
        }
        
        statusText += ` | ${this.syncCount}`;
        
        this.statusBarItemEl.setText(statusText);
        this.statusBarItemEl.title = 'Vault Sync - Click for status';
        this.statusBarItemEl.onclick = () => this.showSyncStatus();
    }

    async syncVault(customMessage?: string) {
        const { syncScript, showNotifications } = this.settings;
        const vaultPath = (this.app.vault.adapter as any).basePath;
        
        const startTime = new Date();
        const timestamp = startTime.toISOString().slice(0, 16).replace('T', ' ');
        const message = customMessage || `Vault sync - ${timestamp}`;
        const command = `cd "${vaultPath}" && bash ${syncScript} "${message}"`;

        try {
            if (showNotifications) {
                new Notice('🔄 Starting vault sync...', 2000);
            }

            const { stdout } = await execAsync(command, { timeout: 30000 });

            const endTime = new Date();
            const duration = ((endTime.getTime() - startTime.getTime()) / 1000).toFixed(1);
            
            this.lastSyncTime = endTime.toISOString();
            this.syncCount++;
            await this.saveSettings();
            this.updateStatusBar();

            if (showNotifications) {
                if (stdout.includes('No changes to commit')) {
                    new Notice(`ℹ️ No changes to sync (${duration}s)`, 2000);
                } else {
                    new Notice(`✅ Synced! (${duration}s)`, 2000);
                }
            }
            
        } catch (error) {
            if (showNotifications) {
                new Notice(`❌ Sync failed: ${error.message}`, 3000);
            }
            console.error('Vault Sync Error:', error);
        }
    }

    private showSyncStatus() {
        const timeSince = this.getTimeSinceLastSync();
        const autoStatus = this.settings.autoSyncEnabled ? 
            `✅ Enabled (every ${this.settings.autoSyncInterval} minutes)` : 
            '❌ Disabled';
        
        new Notice(`Auto-sync: ${autoStatus}\nLast sync: ${timeSince}\nTotal syncs: ${this.syncCount}`, 5000);
    }

    private getTimeSinceLastSync(): string {
        if (!this.lastSyncTime) return 'Never';
        
        const now = new Date();
        const lastSync = new Date(this.lastSyncTime);
        const diffMinutes = Math.floor((now.getTime() - lastSync.getTime()) / (1000 * 60));
        
        if (diffMinutes < 1) return 'Just now';
        if (diffMinutes < 60) return `${diffMinutes} minutes ago`;
        
        const diffHours = Math.floor(diffMinutes / 60);
        if (diffHours < 24) return `${diffHours} hours ago`;
        
        const diffDays = Math.floor(diffHours / 24);
        return `${diffDays} days ago`;
    }

    private toggleAutoSync() {
        this.settings.autoSyncEnabled = !this.settings.autoSyncEnabled;
        this.saveSettings();
        
        if (this.settings.autoSyncEnabled) {
            this.setupAutoSync();
            new Notice(`⏰ Auto-sync enabled (every ${this.settings.autoSyncInterval} minutes)`, 3000);
        } else {
            this.clearAutoSync();
            new Notice('🛑 Auto-sync disabled', 2000);
        }
        
        this.updateStatusBar();
    }

    private setupAutoSync() {
        this.clearAutoSync();
        
        if (this.settings.autoSyncEnabled) {
            const intervalMs = this.settings.autoSyncInterval * 60 * 1000;
            this.autoSyncInterval = setInterval(() => {
                this.syncVault();
            }, intervalMs);
        }
    }

    private clearAutoSync() {
        if (this.autoSyncInterval) {
            clearInterval(this.autoSyncInterval);
            this.autoSyncInterval = null;
        }
    }
}

class VaultSyncSettingTab extends PluginSettingTab {
    plugin: VaultSyncPlugin;

    constructor(app: App, plugin: VaultSyncPlugin) {
        super(app, plugin);
        this.plugin = plugin;
    }

    display(): void {
        const { containerEl } = this;
        containerEl.empty();

        containerEl.createEl('h2', { text: 'Vault Sync Settings' });

        // Status display
        const statusDiv = containerEl.createDiv();
        statusDiv.style.background = '#f5f5f5';
        statusDiv.style.padding = '15px';
        statusDiv.style.borderRadius = '5px';
        statusDiv.style.marginBottom = '20px';
        
        statusDiv.innerHTML = `
            <h3>Current Status</h3>
            <p><strong>Auto-sync:</strong> ${this.plugin.settings.autoSyncEnabled ? 
                `✅ Enabled (${this.plugin.settings.autoSyncInterval}m)` : '❌ Disabled'}</p>
            <p><strong>Last sync:</strong> ${this.plugin.getTimeSinceLastSync()}</p>
            <p><strong>Total syncs:</strong> ${this.plugin.syncCount}</p>
            <p><strong>Script:</strong> ${this.plugin.settings.syncScript}</p>
        `;

        // Sync script selection
        new Setting(containerEl)
            .setName('Sync Script')
            .setDesc('Which sync script to use')
            .addDropdown(dropdown => dropdown
                .addOption('sync-vault.sh', 'Basic')
                .addOption('sync-vault-advanced.sh', 'Advanced')
                .addOption('sync-vault-optimized.sh', 'Optimized')
                .setValue(this.plugin.settings.syncScript)
                .onChange(async (value) => {
                    this.plugin.settings.syncScript = value;
                    await this.plugin.saveSettings();
                    this.display();
                }));

        // Auto-sync toggle
        new Setting(containerEl)
            .setName('Enable Auto-sync')
            .setDesc('Automatically sync at regular intervals')
            .addToggle(toggle => toggle
                .setValue(this.plugin.settings.autoSyncEnabled)
                .onChange(async (value) => {
                    this.plugin.settings.autoSyncEnabled = value;
                    await this.plugin.saveSettings();
                    
                    if (value) {
                        this.plugin.setupAutoSync();
                    } else {
                        this.plugin.clearAutoSync();
                    }
                    
                    this.plugin.updateStatusBar();
                    this.display();
                }));

        // Auto-sync interval
        new Setting(containerEl)
            .setName('Auto-sync Interval')
            .setDesc('Minutes between automatic syncs')
            .addSlider(slider => slider
                .setLimits(1, 60, 1)
                .setValue(this.plugin.settings.autoSyncInterval)
                .setDynamicTooltip()
                .onChange(async (value) => {
                    this.plugin.settings.autoSyncInterval = value;
                    await this.plugin.saveSettings();
                    if (this.plugin.settings.autoSyncEnabled) {
                        this.plugin.setupAutoSync();
                    }
                    this.plugin.updateStatusBar();
                    this.display();
                }));

        // Show notifications
        new Setting(containerEl)
            .setName('Show Notifications')
            .setDesc('Display sync status messages')
            .addToggle(toggle => toggle
                .setValue(this.plugin.settings.showNotifications)
                .onChange(async (value) => {
                    this.plugin.settings.showNotifications = value;
                    await this.plugin.saveSettings();
                }));

        // Actions
        containerEl.createEl('h3', { text: 'Actions' });
        
        new Setting(containerEl)
            .setName('Sync Now')
            .setDesc('Manually trigger a sync')
            .addButton(button => button
                .setButtonText('🔄 Sync')
                .onClick(() => this.plugin.syncVault()));

        new Setting(containerEl)
            .setName('View Status')
            .setDesc('Show detailed sync status')
            .addButton(button => button
                .setButtonText('📊 Status')
                .onClick(() => this.plugin.showSyncStatus()));

        new Setting(containerEl)
            .setName('Reset Counter')
            .setDesc('Reset sync counter to zero')
            .addButton(button => button
                .setButtonText('🔄 Reset')
                .onClick(async () => {
                    this.plugin.syncCount = 0;
                    await this.plugin.saveSettings();
                    this.plugin.updateStatusBar();
                    this.display();
                    new Notice('Counter reset');
                }));
    }
}
