window.addEventListener("message", function(event){
    let item = event.data;

    if (item.response == "openTarget"){
        $(".target").css("display", "block");
        $("#options-left").html("");
        $("#options-right").html("");

    } else if (item.response == "closeTarget"){
        $(".target").css("display", "none");
        $("#options-left").html("");
        $("#options-right").html("");

    } else if (item.response == "validTarget"){
        $("#options-left").html("");
        $("#options-right").html("");

        $.each(item.data, function(index, data){
            let iconClass = data.icon ? data.icon : "fa-solid fa-circle";
            
            let html = `
                <div class="option-item" id="target-${index}">
                    <i class="${iconClass} option-icon"></i>
                    <span>${data.label}</span>
                </div>
            `;

            if (index % 2 === 0) {
                $("#options-right").append(html);
            } else {
                $("#options-left").append(html);
            }

            $("#target-" + index).data("TargetData", data.event);
            $("#target-" + index).data("TunnelData", data.tunnel);
            $("#target-" + index).data("ServiceData", data.service);
        });

        // AQUI APLICAMOS A CURVA RADIAL
        applyCurve();

        $(".option-item").click(function(){
            let eventName = $(this).data("TargetData");
            let tunnel = $(this).data("TunnelData");
            let service = $(this).data("ServiceData");

            $.post("http://target/selectTarget", JSON.stringify({ 
                event: eventName, 
                tunnel: tunnel, 
                service: service 
            }));

            $(".target").css("display", "none");
        });

    } else if (item.response == "leftTarget"){
        $(".target").css("display", "none");
        $.post("http://target/closeTarget");
    }

    document.onkeyup = data => {
        if (data.key === "Escape"){
            $(".target").css("display", "none");
            $.post("http://target/closeTarget");
        }
    };
});

// Função matemática para criar o arco
function applyCurve() {
    // Configuração da curva
    const curveIntensity = 20; // Quanto maior, mais curvado fica (pixels)

    // Aplica na Esquerda
    let leftItems = $("#options-left .option-item");
    let leftCenter = (leftItems.length - 1) / 2;
    
    leftItems.each(function(index) {
        // Calcula a distância do centro vertical (ex: -1, 0, 1)
        let dist = Math.abs(index - leftCenter);
        // Calcula o afastamento (curva exponencial suave)
        let offset = (dist * dist) * 10; 
        
        // Empurra para a ESQUERDA (negativo)
        $(this).css("transform", `translateX(-${offset}px)`);
    });

    // Aplica na Direita
    let rightItems = $("#options-right .option-item");
    let rightCenter = (rightItems.length - 1) / 2;

    rightItems.each(function(index) {
        let dist = Math.abs(index - rightCenter);
        let offset = (dist * dist) * 10;
        
        // Empurra para a DIREITA (positivo)
        $(this).css("transform", `translateX(${offset}px)`);
    });
}