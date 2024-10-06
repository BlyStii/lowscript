# LowScript

LowScript is an interpreted language made entirely in LUA and converted into a stand-alone EXE file.
It was created for programmers that want to code fast with a comprehensible and easy language.

###### Windows & Unix versions provided by OpenAI. If you encounter any bugs, contact me on Discord: [`bly.stii`](https://discord.com/channels/@me) or join the [`LowScript Discord server`](https://discord.gg/gEXDRkYxks)

## Step 1: Downloading LowScript

You can download the latest version of LowScript by cloning the repository:

### Windows

```batch
git clone https://github.com/blystii/lowscript.git    &:: Cloning the LowScript repository into new directory `lowscript`.
```

### Unix

### For Bash:

```bash
git clone https://github.com/blystii/lowscript.git    # Cloning the LowScript repository into new directory `lowscript`.
```

### For Zsh:

```zsh
git clone https://github.com/blystii/lowscript.git    # Cloning the LowScript repository into new directory `lowscript`.
```

## Step 2: Setting up the environment variable

To make LowScript easily accessible from anywhere in the terminal, you'll have to create an [environment variable](https://en.wikipedia.org/wiki/Environment_variable).

### To create an environment variable:

Open the terminal as an Administrator and run this/these command(s):

### Windows

```batch
setx PATH "%PATH%;<lowscript_path>" /m                &:: Adding path to `lowscript.exe` to your current PATH variable.
```

### Unix

### For Bash:

```bash
nano ~/.bashrc                                        # Opening or creating the `.zshrc` file in your home directory.
export PATH="PATH:<lowscript_path>"                   # Adding path to `lowscript.exe` to your current PATH variable.
source ~/.bashrc                                      # Applying the changes.
```

### For Zsh:

```zsh
nano ~/.zshrc                                         # Opening or creating the `.zshrc` file in your home directory.
export PATH="PATH:<lowscript_path>"                   # Adding path to `lowscript.exe` to your current PATH variable.
source ~/.zshrc                                       # Applying the changes.
```

#

###### Replace `<lowscript_path>` with the actual directory where `lowscript.exe` is located.

## Step 3: Verifying the setup

To verify that LowScript is now accessible, open a new terminal and run this command:

### Windows

```batch
lowscript --version                                   &:: Checking LowScript's version.
```

### Unix

### For Bash:

```bash
lowscript --version                                   # Checking LowScript's version.
```

### For Zsh:

```zsh
lowscript --version                                   # Checking LowScript's version.
```

## Step 4: Using LowScript

To run a LowScript file:

### Windows

```batch
lowscript <prog.ls>                                   &:: Running a LowScript file.
```

### Unix

### For Bash:

```bash
lowscript <prog.ls>                                   # Running a LowScript file.
```

### For Zsh:

```zsh
lowscript <prog.ls>                                   # Running a LowScript file.
```

#

###### Replace `<prog.ls>` with your desired LowScript file.

#

To use the LowScript terminal:

### Option 1:

Double-click or right-click then click 'Open' on the `lowscript.exe` file.

### Option 2:

Type `lowscript` in the terminal, that starts the LowScript terminal inside your own terminal.

#

### Exiting the LowScript terminal

To exit the LowScript terminal, run this command:

```
> *EXIT
```

#

Now you're all done and can use the LowScript language however you want.

### Join the [official discord server](https://discord.gg/gEXDRkYxks) to be up to date with the language and possibly interact with other LowScript users.