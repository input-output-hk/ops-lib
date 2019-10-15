self: super: {
  nginxMainline = super.nginxMainline.override
    (oldAttrs: { modules = oldAttrs.modules ++ [ self.nginxModules.vts ]; });

  nginxStable = super.nginxStable.override
    (oldAttrs: { modules = oldAttrs.modules ++ [ self.nginxModules.vts ]; });
}
