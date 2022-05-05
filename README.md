# Conda Environments and Jupyter Kernels

## The problem with `pip install`

While `pip` is easy to use and works for many use cases, there are some major drawbacks. If you have spent any time working in Python, you will likely have seen (and may have run) suggestions to `pip install ____`, or within Jupyter `!pip install ____`, to install this package or that package. That will generally work...up to a point. There are a few issues with doing `pip install`:

1. If you install a version of a package that is also installed in by UFRC (either now or in the future), your version will take precedence. Your version appears in the the `PYTHON_PATH` before the UFRC installed version. That may be fine *now*, but some time down the road there may be a newer version installed by UFRC for compatibility with something else and your older version still takes precedence and breaks the other package. This can be hard to diagnose when things start failing as you have likely forgotten that you installed the package in the first place.
1. You may want to install something that needs a different version of a package. Sometimes, the unfortunate reality is that two packages cannot co-exist because they require different versions of dependencies. This becomes a challenge to manage with `pip` as there isn't a method to swap active versions.
1. `pip` installs **everything** in one locations: `~/.local/lib/python3.X/site-packages/`. All packages installed are in the same location for any given version of Python.

## Conda and Mamba to the rescue!

<img src='https://mamba.readthedocs.io/en/latest/_static/logo.png' alt='Mamba logo' width='200' align='right'>

`conda` and the newer, faster, drop-in replacement `mamba`, were written to solve some of these issues. They allow you to have different environments and switch between environments as needed. They also make it much easier to report the exact configuration of modules that are needed to run some code, facilitating reproducibility.

Check out the [UFRC Help page on conda](https://help.rc.ufl.edu/doc/Conda)

The rest of this tutorial will walk through setting up an environment and then a kenrel to use that environment in Jupyter.

### A caveat

`conda` and `mamba` pull packages from repositories where people post pre-packaged python packages. While there are several available repositories, like the main `conda-forge`, not every Python package is available via `conda`. You may still need to use `pip` to install some things...as noted later, `conda` still helps manage the environment by installing packages within the environment rather than everything in a single folder.


## 1. Edit your `~/.condarc` file

`conda` environments contain all of the packages installed within the environment as well as a Python version. They can quickly grow in size and, especially if you have many environments, fill the 40GB of space provided in your home directory. As such, it is important to change the default and move the storage location from your home directory to your folder in `/blue/`.

To do so, edit or create your `~/.condarc` to use `/blue/group/user/conda/`, replacing `group` with your group name, and `user` with your username. **Note:** This file is in your home directory (`~/`) and hidden (starts with a dot).

One way to do this is to type: `nano ~/.condarc`
If the file is empty, paste in the text below, editing the `env_dirs:` and `pkg_dirs` as below. If the file has contents, update those lines.

 > Your `~/.condarc` should look something like this when you are done editing (again, replacing `group` and `user` in the paths with your group and username):

```bash
channels:
- conda-forge
- bioconda
- defaults
envs_dirs:
- /blue/group/user/conda/envs
pkgs_dirs:
- /blue/group/user/conda/pkgs
auto_activate_base: false
auto_update_conda: false
always_yes: false
show_channel_urls: false
```

## 2. Create your first environment

2.1. Before we can run `conda` or `mamba` on HiPerGator, we need to load the `conda` module:

`module load conda`

2.2. To create your first environment, run the following command. In this example, I am creating an environment named `hfrl`

`mamba create -n hfrl`

Here's a screenshot of the output from running that command. Yours should look similar.

![Screenshot of output of running mamba create -n hfrl](images/mamba_create.png)

> **Note:** You do not need to manually create the folders that you setup in step 1. `mamba` will take care of that for you.

## 3. Activate the new environment

To actiate our environment (whether created with `mamba` or `conda` we use the `conda activate env_name` command. Let's activate our new environment:

`conda activate hfrl`

Notice that your command prompt changes when you activate an environment to indicate which environment is active showing that in parentheses before the other information:

> `(hfrl) [magitz@c0907a-s23 magitz]$ ` 

## 4. Add stuff to our environment with `mamba install`

Now we are ready to start adding things to our environment.

There are a few ways to do this. We can install things one-by-one with either `mamba install ____` or `pip install ____`.

> **Note:** when an environment is active, running `pip install` will install the package *into that environment*. So, even if you continue using `pip`, adding `conda` environments solves the problem of everything being installed in one location--each environment has its own `site-packages` folder and is isolated from other environments.

4.1 Install gym-boxd2:

`mamba install gym-box2d`

When you run that command, `mamba` will look in the repositories for the `gym-box2d` package and its dependencies. Here's a screenshot of part of the output:

![Screenshot of mamba install gym-box2d](images/mamba_install.png)

`mamba` will list the packages it will install and ask you to confirm the changes. Typing 'y' or hitting return will proceed; 'n' will cancel:

![Screenshot of mamba install confirmation](images/mamba_confirm.png)

Finally, `mamba` will summarize the results:

![Screenshot of mamba install summary](images/mamba_success.png)

4.2. We also need to:
> `mamba install stable-baselines3`


## 5. Add stuff to our environment with `pip install`

As noted above, not everything is available in a `conda` repository. For example the next thing we want to install is `huggingface_sb3`.

If we type `mamba install huggingface_sb3`, we get a message saying nothing provides it:

![Screenshot of nothing provides huggingface_sb3 error](images/mamba_not_available.png)

If we know of a conda source that has that package, we can add it to the `channels:` section of our `~/.condarc` file. That will prompt `mamba` to include that location when searching. 

But many things are only available via `pip`. So...

`pip install huggingface_sb3` 

That will install `huggingface_sb3`. Again, because we are using environments and have the `hfrl` environment active, `pip` will not install `huggingface_sb3` in our `~/.local/lib/python3.X/site-packages/` directory, but rather within in our `hfrl` directory, at `/blue/group/user/conda/envs/hfrl/lib/python3.10/site-packages`. This prevents the issues and headaches mentioned at the start.

5.2 We also need:

`pip install ale-py==0.7.4`











2.3. Then to get the tensorflow compiled with the latest CUDA for the A100s:

`mamba install tensorflow==2.7.0=cuda112*`

> **Note:** if you just `mamba install tensorflow`, you will get a version compiled with an older CUDA, which will be ***extremely*** slow...ask me how I know 🤦

Then add in other stuff:

`mamba install jupyterlab transformers huggingface_hub tensorboard ipywidgets datasets pillow matplotlib scikit-learn seaborn kaggle opencv`

And...of course...`tensorflow-addons` is not in conda yet, so I had to `pip install tensorflow-addons`. Same with `vit-keras`. The good thing is, if you `mamba activate vit` and then run `pip install tensorflow-addons` that is installed in the virtual environment.

## Adding the `vit` environment as a Jupyter kernel

Now we need to add this environment as a Jupyter kernel so that we can select this environment to run our notebook.

Again, while UFRC manages the environments that are globally available, you can always add your own. The steps are outlined on the [UFRC Jupyter page](https://help.rc.ufl.edu/doc/Jupyter_Notebooks#Personal_Kernels)

<img src='https://github.com/AIBiology/Jupyter_Content/blob/main/kernels/vit/logo-64x64.png?raw=true' alt='ViT Kernel logo' align='left'>

I have prepared the kernel and it's in the `kernels` folder of the `Jupyter_Content` repo.

In addition to the global kernels, Jupyter will look in your directory `~/.local/share/jupyter/kernels/` for personal kernels.

After pulling the latest version of the repo, open a terminal and run these commands (or use the repo at `/blue/zoo4926/share/Jupyter_Content` as below)

```bash
# Change to the path where you have the Jupyter_Content repo
cd /blue/zoo4926/share/Jupyter_Content/kernels
# Copy the vit folder to ~/.local/share/jupyter/kernels/
cp -r vit ~/.local/share/jupyter/kernels/
```

Now, refresh the Jupyter tab in your browser. You should now have a ViT Kernel in the list of available kernels!
