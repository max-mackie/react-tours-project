// App.js
import React, { Component } from "react";
// import { Loading } from "./components/loading";
import { Tours } from "./components/Tours";
const url = "https://course-api.netlify.app/api/react-tours-project";

function App() {
  const [loading, setLoading] = useState(true);
  const [tours, setTours] = useState([]);
  return (
    <>
      <h2>tours project</h2>
    </>
  );
}

export default App;
