# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...   

Here is the full `README.md` markdown text that you can copy without any formatting issues:

```markdown
# Ruby On Rails Development Environment Setup

## Set up a VirtualBox VM
1. Download and install the VirtualBox platform onto your PC.
2. Set up an Ubuntu Linux Virtualbox VM.

### Set up the VM for development

To connect from Visual Studio Code (VSCode) to a VirtualBox VM, you can use the **Remote - SSH** extension, which allows you to connect to remote servers (in this case, your VirtualBox VM) via SSH. Here’s a step-by-step guide to set this up:

### Set up SSH on the VM
Before you can connect from VSCode, your VirtualBox VM must be running an SSH server. If it's not pre-installed, follow these steps to install and configure OpenSSH:

```bash
sudo apt update
sudo apt install openssh-server
sudo systemctl enable ssh
sudo systemctl start ssh
sudo systemctl status ssh # validate ssh service is running
```

### Add SSH Host Configuration to VSCode
Add an SSH host configuration to VSCode:

```bash
Remote-SSH: Add New SSH Host -> %USERPROFILE%\.ssh\config
```

Example configuration:
```bash
Host virtualbox-vm
    HostName localhost
    User <your-username>
    Port 2222
```

### Get the Virtual Machine IP
```bash
ip a
```

### Set up SSH Key Authentication
Set up SSH key authentication from your PC to the VM:

```bash
ssh-keygen -t rsa -b 4096 -C "<your-github-email>"
ssh-copy-id <your-username>@<your-vm-ip>
```

### Set up Port Forwarding (Optional)
If you have a firewall or are using NAT networking mode, you may need to set up port forwarding:

1. Open VirtualBox and select your VM.
2. Click on **Settings** → **Network**.
3. Under the **Adapter** tab, set the adapter to **NAT**.
4. Go to **Advanced** → **Port Forwarding**, and add a new rule:
    - **Name**: SSH
    - **Protocol**: TCP
    - **Host IP**: (leave blank or use 127.0.0.1)
    - **Host Port**: 2222
    - **Guest IP**: (leave blank)
    - **Guest Port**: 22

### Connect to the VM from VSCode
```bash
Ctrl+Shift+P -> Remote-SSH: Connect to Host
```

---

## Coding Setup

```bash
gem install rails
bundle config set --local path 'vendor/bundle'
```

For a Turbo Rails-enabled app, follow the first steps of the [Turbo Rails Tutorial](https://www.hotrails.dev/turbo-rails/turbo-rails-tutorial-introduction) with the following changes:

```bash
rails new quote-editor --css=sass --javascript=esbuild --database=postgresql
cd quote-editor
sudo npm install -g yarn
bin/setup
sudo npm install -g sass
sudo npm install -g esbuild
sudo npm install -g n
sudo n stable
sudo yarn add @hotwired/turbo-rails @hotwired/stimulus
bin/dev
```

Now you should have a running Rails app.

---

## Source Control

1. Log in to your github account and create a new repository
2. Get your vm ssh key from id_rsa.pub and createa a Deploy Key in the new repo:
```bash
ssh-keygen -t rsa -b 4096 -C "<your-github-email>"
cat ~/.ssh/id_rsa.pub
```
3. Initialize your local git repo
```bash
git init
git config --global user.email "<your-github-email>"
git config --global user.name "<your-name>"
git remote add origin <yout-git-repo-url>
```

4. Add, commit and push your code
```
git add .
git commit -m "Initial commit"
git push

```
---

## Debugging

To set up debugging for a Rails app in VSCode using Shopify's Ruby LSP:

1. Install Ruby LSP by Shopify from the Extensions view (`Ctrl+Shift+X`).
2. Install the Ruby Debugger Gem:
    ```bash
    bundle exec rdbg -v
    ```

3. Configure Debugging in VSCode:
    ```bash
    Debug: Add configuration... (Ctrl+Shift+P)
    ```

Example `launch.json` configuration:
```json
{
    "version": "0.2.0",
    "configurations": [
        {
            "type": "ruby_lsp",
            "name": "Debug script",
            "request": "launch",
            "program": "ruby ${file}"
        },
        {
            "type": "ruby_lsp",
            "name": "Debug test",
            "request": "launch",
            "program": "ruby -Itest ${relativeFile}"
        },
        {
            "type": "ruby_lsp",
            "name": "Attach debugger",
            "request": "attach"
        },
        {
            "type": "ruby_lsp",
            "name": "Debug Rails Server",
            "request": "launch",
            "program": "${workspaceFolder}/bin/rails server",
            "env": {
                "DEBUGGER": "true"
            }
        }
    ]
}
```

---

## Testing Setup

### Install Testing Dependencies

```bash
sudo apt-get update
sudo apt-get install -y libnss3 libgconf-2-4 libxi6 libgpm-dev
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo apt install ./google-chrome-stable_current_amd64.deb
```

Install ChromeDriver:
```bash
ver=$( /usr/bin/google-chrome --version | grep -oP "\d+\.\d+\.\d+\.\d+" )
wget https://edgedl.me.gvt1.com/edgedl/chrome/chrome-for-testing/$ver/linux64/chromedriver-linux64.zip
unzip chromedriver-linux64.zip
sudo cp chromedriver-linux64/chromedriver /usr/bin/
gem install selenium-webdriver
```

### Validate Chrome Versions

```bash
/usr/bin/google-chrome --version
chromedriver --version
```

### Standalone Test Example (`selenium_test.rb`)

```ruby
require 'selenium-webdriver'
begin
  options = Selenium::WebDriver::Chrome::Options.new
  options.add_argument('--headless')
  options.add_argument('--disable-gpu')
  options.add_argument('--no-sandbox')
  options.add_argument('--disable-dev-shm-usage')
  options.add_argument('--window-size=1400,1400')

  service = Selenium::WebDriver::Service.chrome(args: ['--log-path=chromedriver.log'])

  driver = Selenium::WebDriver.for :chrome, options: options, service: service

  driver.navigate.to "http://www.google.com"
  puts "Title: #{driver.title}"

  driver.quit
rescue Selenium::WebDriver::Error::SessionNotCreatedError => e
  puts "Error: #{e.message}"
end
```

Run the test:
```bash
ruby selenium_test.rb
```

---

## CSSing

We follow the BEM methodology (Block-Element-Modifier) for naming conventions:

- **Class name**: `.card`
- **Element names**: `.card__title`, `.card__body`
- **Modifier names**: `.card--primary`, `.card--secondary`

### Mobile First Approach
Write CSS for mobile first, then add overrides for larger screens.

### CSS Structure

```bash
app/assets/stylesheets/
├── mixins/
│   └── _media.scss
├── config/
│   └── _variables.scss
│   └── _reset.scss
├── components/
│   └── _btn.scss
│   └── _quote.scss
│   └── _form.scss
│   └── _visually_hidden.scss
│   └── _error_message.scss
└── layouts/
    └── _container.scss
    └── _header.scss
```

Update the manifest (`app/assets/stylesheets/application.sass.scss`) with all imports (`@use`).

---

Now your Rails development environment is set up and ready for coding, debugging, testing, and styling!
```

This is the full markdown that you can copy directly into your `README.md` file. It should render perfectly once pasted. Let me know if you need further assistance!