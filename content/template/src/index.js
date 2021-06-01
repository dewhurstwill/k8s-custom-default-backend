import React from 'react';
import ReactDOM from 'react-dom';
import './index.css';

ReactDOM.render(
  <React.StrictMode>
    <div id="notfound">
      <div className="notfound">
        <div className="notfound-404">
          <h1>404</h1>
          <h2>Page not found</h2>
        </div>
        <a href={process.env.REACT_APP_REDIRECT || '#'}>Homepage</a>
      </div>
    </div>
  </React.StrictMode>,
  document.getElementById('root')
);
