const counter = document.querySelector(".counter-number");
async function updateCounter() {
    let response = await fetch ("https://yivqqmoszglhobwv43q637w7am0oyrqg.lambda-url.ap-southeast-1.on.aws/");
    let data = await response.json();
    counter.innerHTML = `Views: ${data}`;
}

updateCounter();