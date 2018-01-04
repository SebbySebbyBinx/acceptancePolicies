function fSetPlotSizeAndSave()
    set(findall(gcf,'Type','text'), 'fontSize', 18, 'fontname', 'Times New Roman', 'FontWeight', 'Normal');
    set(gcf,'color','w'); %set background white  
    ax = gca;
    set(ax,'FontSize',18,'fontname', 'Times New Roman');
    ax.TitleFontSizeMultiplier = 1.3;
    fig = gcf;
    fig.Position = [ 0 0 1100 500];
    set(gca, 'Position', get(gca, 'OuterPosition') - get(gca, 'TightInset') * [-1 0 1 0; 0 -1 0 1; 0 0 1 0; 0 0 0 1]);

    saveas(fig,[pwd '/figures/' fig.Name '.fig'])
    print( ['figures/' fig.Name '.png'], '-dpng')
    print( ['figures/' fig.Name '.eps'], '-depsc2','-loose')
end