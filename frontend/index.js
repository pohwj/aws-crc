const counter = document.querySelector(".counter-number");
async function updateCounter() {
    let response = await fetch ("https://unnbs7fvskee3dhtbeydbvk5fu0yenqq.lambda-url.ap-southeast-1.on.aws/");
    let data = await response.json();
    counter.innerHTML = `Views: ${data}`;
}

updateCounter();