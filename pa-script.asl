state("Prison Architect64")
{
    // =========================
    // VARIÁVEIS DE JOGO
    // =========================

    // Quantidade de prisioneiros
    int prisoners : "PrisonArchitect64.exe", 0x6EC870, 0x30;

    // Dinheiro (conforme você informou)
    long money : "PrisonArchitect64.exe", 0x5A1DA7;

    // 1 = menu | 0 = jogo
    int inMenu : "PrisonArchitect64.exe", 0x495B70;
}

startup
{
    vars.runStarted = false;
    vars.splitArmed = false;
}

settings
{
    // Trigger de split:
    // "Prisoners"
    // "Money"
    // "None"
    SplitTrigger = "Prisoners";

    PrisonerTarget = 50;
    MoneyTarget = 100000;
}

update
{
    // Detecta início da run
    if (!vars.runStarted && old.inMenu == 1 && current.inMenu == 0)
    {
        vars.runStarted = true;
        vars.splitArmed = true;
    }

    // Re-arma o split quando voltar abaixo do alvo
    if (vars.runStarted)
    {
        if (settings.SplitTrigger == "Prisoners")
        {
            if (current.prisoners < settings.PrisonerTarget)
                vars.splitArmed = true;
        }

        if (settings.SplitTrigger == "Money")
        {
            if (current.money < settings.MoneyTarget)
                vars.splitArmed = true;
        }
    }
}

start
{
    return old.inMenu == 1 && current.inMenu == 0;
}

reset
{
    if (current.inMenu == 1)
    {
        vars.runStarted = false;
        vars.splitArmed = false;
        return true;
    }
    return false;
}

split
{
    if (!vars.runStarted || !vars.splitArmed)
        return false;

    if (settings.SplitTrigger == "Prisoners")
    {
        if (old.prisoners < settings.PrisonerTarget
         && current.prisoners >= settings.PrisonerTarget)
        {
            vars.splitArmed = false;
            return true;
        }
    }

    if (settings.SplitTrigger == "Money")
    {
        if (old.money < settings.MoneyTarget
         && current.money >= settings.MoneyTarget)
        {
            vars.splitArmed = false;
            return true;
        }
    }

    return false;
}