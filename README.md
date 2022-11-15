# deploy.sh

`deploy.sh` is a simple command line app that allows you to record repositories from your local machine and run a deploy command that you can choose as an option command.

## Installation

You just need to run the `install.sh` file.

Recommened way to install it.

```bash
curl https://raw.githubusercontent.com/itmarck/deploy.sh/main/install.sh | bash
```

## Usage

```
Usage: deploy [OPTION]... [REPOSITORY]...
```

### Guide to use

Basic instructions to start using the command.

```bash
# List available repositories
deploy

# Add a repository where REPOSITORY is the path to the repository
deploy --add REPOSITORY

# Run a deployment file by repository name
# To specify the deployment file, use the --file option
deploy REPOSITORY

# Remove a repository by name
deploy --remove REPOSITORY

# Remove all repositories
deploy --clean

# Show command version
deploy --version

# Show command help
deploy --help
```

### Flags

Available flags to use with the command.

```
  -a, --add                  Add REPOSITORY to the list
  -c, --clean                Clean all repositories
  -f, --file                 Specify the deployment filename (default: deploy.sh)
  -r, --remove               Remove the REPOSITORY
  -v, --verbose              Print verbose output
      --help                 Show this help information
      --version              Show command version
```

## Updating

The installation process use a detailed copy of the repository and it doesn't override the data storaged. So you can safely update by running the `install.sh` file again or by running the installation command specified above.

## Uninstalling

To uninstall the command, just remove the `deploy` file and the `.deploy` folder from `/usr/local/bin` folder.
