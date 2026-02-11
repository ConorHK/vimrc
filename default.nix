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
  ty,
  ruff,
  bash-language-server,
  jdt-language-server,
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
    ty
    ruff
    bash-language-server
    jdt-language-server
    typescript-language-server
    universal-ctags
    ripgrep
    fd
    sqlite
  ];

  startPlugins =
    with vimPlugins;
    [
      blink-cmp
      comment-nvim
      fugitive
      gitsigns-nvim
      inc-rename-nvim
      indent-blankline-nvim
      luasnip
      no-neck-pain-nvim
      nvim-lspconfig
      nvim-treesitter.withAllGrammars
      nvim-web-devicons
      oil-nvim
      project-nvim
      smartyank-nvim
      smear-cursor-nvim
      snacks-nvim
      statuscol-nvim
      trouble-nvim
      vim-illuminate
      vim-python-pep8-indent
      zellij-nav-nvim
    ]
    ++ lib.optionals (neovimPlugins ? alduin) [
      neovimPlugins.alduin
    ];

  foldPlugins =
    let
      go =
        seen:
        builtins.foldl' (
          acc: next:
          if builtins.elem next acc then
            acc
          else
            acc ++ [ next ] ++ (go (seen ++ [ next ]) (next.dependencies or [ ]))
        ) seen;
    in
    go [ ];

  startPluginsWithDeps = lib.unique (foldPlugins startPlugins);

  packpath = runCommandLocal "packpath" { } ''
    mkdir -p $out/pack/${packageName}/{start,opt}

    ${lib.concatMapStringsSep "\n" (
      plugin: "ln -vsfT ${plugin} $out/pack/${packageName}/start/${lib.getName plugin}"
    ) startPluginsWithDeps}

    cp -r ${./lua} $out/lua
    cp -r ${./snippets} $out/snippets
    cp -r ${./lspconfigs} $out/lspconfigs
    cp ${./init.lua} $out/init.lua
  '';
in
symlinkJoin {
  name = packageName;
  paths = [ neovim-unwrapped ];
  nativeBuildInputs = [ makeWrapper ];
  postBuild = ''
    wrapProgram $out/bin/nvim \
      --add-flags '-u' \
      --add-flags '${packpath}/init.lua' \
      --add-flags '--cmd' \
      --add-flags "'set packpath^=${packpath} | set runtimepath^=${packpath}'" \
      --set-default NVIM_APPNAME ${packageName} \
      --prefix PATH : ${lib.makeBinPath runtimeDeps}
  '';

  passthru = {
    inherit packpath;
  };
}
