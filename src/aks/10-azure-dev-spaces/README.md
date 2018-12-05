# Azure Dev Spaces for AKS

What is Azure Dev Spaces? Basically ADS is development too to work with microservices with Kubernetes, it solves the problem of having a huge cluster and not bing able to perform a test with a particular microservice without the necessity to either run all the dependecies in your local machine or create mock up for all the other services.

With a minimal effort your can setup your enviroment to use Visual Studio Code or Visual Studio 2017 (.NET Core, Java, Node.Js).

Check the product documentation for more info [here](https://docs.microsoft.com/en-us/azure/dev-spaces/).

## Enabling Azure Dev Spaces

Dependencies:

- [Azure Cli  2.0.43 or higher](https://docs.microsoft.com/cli/azure/install-azure-cli?view=azure-cli-latest)
- [Visual Studio Code](https://code.visualstudio.com/download)
- [ADS Visual Studio Code Extension](https://marketplace.visualstudio.com/items?itemName=azuredevspaces.azds)
  
Enabling AKS Cluster to use ADS

``` md
az aks use-dev-spaces -g `<aks resource group name>` -n `<aks name>`
```

``` bash
az aks use-dev-spaces -g aks-demo -n aks-demo
```

After runnig the command above a new pop-up windows will apper, accept the license agreement and clicks over ok to continue.

At the terminal also accept the creation of http addon for the AKS.

This command will prepare your AKS and also your environment by installing a command line tool called *azds*.

Execute the command to see the options.

``` bash
azds

Azure Dev Spaces CLI (Preview) 0.1.20181116.14

Usage: azds [options] [command]

Options:
  -h|--help  Show help information
  --version  Show version information

Commands:
  controller    Manage Azure Dev Spaces Controllers
  down          Stop a dev space workload
  exec          Execute a command in a dev space workload
  list-up       List dev space workload objects that are running
  list-uris     List uris for dev space workloads
  prep          Prepare a local source directory for use with Azure Dev Spaces
  remove        Remove Azure Dev Spaces from a managed Kubernetes cluster
  show-context  Show the current Azure Dev Spaces context
  space         Manage dev spaces in the current Azure Dev Spaces Controller
  up            Start or refresh a dev space workload
  use           Use Azure Dev Spaces with a managed Kubernetes cluster

Use "azds [command] --help" for more information about a command.

Common Options:
  -q|--quiet    Output no information during command execution
  -v|--verbose  Output more information during command execution
  -o|--output   Output format. Allowed values: json, table. Default: table.
```

azds works like Draft

For demo we are going to use the [Azure Dev Spaces Repo on GitHub](https://github.com/Azure/dev-spaces.git), the .Net Core sample.

## Showing the azds tool

Access the webfrontend folder, and execute *azds prep*

``` bash
cd dotnetcore/getting-started/webfrontend
azds prep
```

After that we will run with *azds up*

``` bash
azds up
```

Open the browser and access the address presented i.e, *localhost:59312*.

When you are done, hit `<ctrl+c>`

Now change some file, for instance. *./views/shared/_Layout.cshtml* and change the page tile for something else.

Save, and run **azks up**

## Debuging

Now it's time to debug your code remotely using the AZDS extension for Visual Studio Code.

First we need to open a new instance of VSCode from the webfrontend project, this is because of the existence of azds.yaml file that the extension looks for to enable debug by changing the .vscode file.

After that open the debug tool, and change the dropbox to *.NET Core Launch (AZDS)*.

Add one breakpoint to the HomeController, and test it hiting play.

