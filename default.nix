{
  symlinkJoin,
  neovim-unwrapped,
  makeWrapper,
  runCommandLocal,
  vimPlugins,
  neovimPlugins ? { },
  lib,

  lua-language-server,
  nixd,
  pyright,
  ruff,
  bash-language-server,
  jdt-language-server,
  jdk21_headless,
  typescript-language-server,

  universal-ctags,
  ripgrep,
  fd,
  sqlite,
}:
let
  packageName = "cnvim";

  runtimeDeps = [
    lua-language-server
    nixd
    pyright
    ruff
    bash-language-server
    jdt-language-server
    typescript-language-server
    universal-ctags
    ripgrep
    fd
    sqlite
  ];

  startPlugins = with vimPlugins; [
    blink-cmp
    nvim-lspconfig
    vim-illuminate
    inc-rename-nvim
    nvim-treesitter.withAllGrammars
    indent-blankline-nvim
    luasnip
    gitsigns-nvim
    fugitive
    comment-nvim
    nvim-web-devicons
    snacks-nvim
    surround-nvim
    grug-far-nvim
    smartyank-nvim
    oil-nvim
    harpoon2
    project-nvim
    trouble-nvim
    smear-cursor-nvim
    nui-nvim
    vim-python-pep8-indent
  ]
  ++ lib.optionals (neovimPlugins ? alduin) [
    neovimPlugins.alduin
  ];

  foldPlugins = builtins.foldl' (
    acc: next:
    acc
    ++ [
      next
    ]
    ++ (foldPlugins (next.dependencies or [ ]))
  ) [ ];

  startPluginsWithDeps = lib.unique (foldPlugins startPlugins);

  packpath = runCommandLocal "packpath" { } ''
    mkdir -p $out/pack/${packageName}/{start,opt}

    ${lib.concatMapStringsSep "\n" (
      plugin: "ln -vsfT ${plugin} $out/pack/${packageName}/start/${lib.getName plugin}"
    ) startPluginsWithDeps}

    cp -r ${./lua} $out/lua
    cp -r ${./after} $out/after
    cp -r ${./lspconfigs} $out/lspconfigs
  '';
in
symlinkJoin {
  name = packageName;
  paths = [ neovim-unwrapped ];
  nativeBuildInputs = [ makeWrapper ];
  postBuild = ''
    wrapProgram $out/bin/nvim \
      --add-flags '-u' \
      --add-flags '${./init.lua}' \
      --add-flags '--cmd' \
      --add-flags "'set packpath^=${packpath} | set runtimepath^=${packpath} | set runtimepath+=${./.}}'" \
      --set-default NVIM_APPNAME nvim-custom \
      --prefix PATH : ${lib.makeBinPath runtimeDeps}
  '';

  passthru = {
    inherit packpath;
  };
}
